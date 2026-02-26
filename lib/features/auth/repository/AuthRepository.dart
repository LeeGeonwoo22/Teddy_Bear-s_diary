// import 'package:clouddb/clouddb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/common/global.dart';

abstract class AuthRepository {
  Future<UserCredential?> guestLogin();
  Future<UserCredential?> signInWithGoogle({String? previousGuestUid});
  Future<void> signOut();
  Future<void> deleteAccount();
  User? getCurrentUser();
  Future<Map<String, dynamic>?> getUserData(String uid);
  Future<void> updateUserData(String uid, Map<String, dynamic> data);
  Future<void> migrateGuestData({required String guestUid, required String socialUid});
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool isInitialize = false;

  Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(
          serverClientId: Server_Client_ID
      );
      isInitialize = true;
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle({String? previousGuestUid}) async {
    try {
      // 1️⃣ 구글 로그인 전에 비회원 데이터 미리 읽기
      Map<String, dynamic>? guestData;
      List<QueryDocumentSnapshot>? guestMessages;
      List<QueryDocumentSnapshot>? guestDiaries;

      if (previousGuestUid != null) {
        print('📦 비회원 데이터 미리 읽는 중...');
        final guestDoc = await db.collection('users').doc(previousGuestUid).get();
        guestData = guestDoc.data();

        if (guestData != null && guestData['isGuest'] == true) {
          // 서브컬렉션도 미리 읽기
          final messagesSnap = await db
              .collection('users').doc(previousGuestUid)
              .collection('messages').get();
          final diariesSnap = await db
              .collection('users').doc(previousGuestUid)
              .collection('diaries').get();

          guestMessages = messagesSnap.docs;
          guestDiaries = diariesSnap.docs;
          print('📦 비회원 데이터 읽기 완료: messages ${guestMessages.length}개, diaries ${guestDiaries.length}개');
        }
      }

      // 2️⃣ 구글 로그인 (여기서 uid 바뀜)
      await initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final googleAuth = await googleUser.authentication;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization =
      await authorizationClient.authorizationForScopes(['email', 'profile']);

      if (authorization?.accessToken == null) {
        authorization = await authorizationClient.authorizationForScopes(['email', 'profile']);
        if (authorization?.accessToken == null) {
          throw FirebaseAuthException(code: "no-access-token", message: "Failed to get access token");
        }
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;
      final socialUid = firebaseUser.uid;

      print('✅ Firebase user uid: $socialUid');

      // 3️⃣ 비회원 → 구글 전환 처리 (이미 읽어둔 데이터로)
      if (previousGuestUid != null && guestData != null && guestData['isGuest'] == true) {
        print('🔄 Guest → Google 전환');

        final batch = db.batch();

        // 비회원 users 문서 → 구글 uid로 저장
        final socialDocRef = db.collection('users').doc(socialUid);
        final socialDocSnap = await socialDocRef.get();

        if (!socialDocSnap.exists) {
          batch.set(socialDocRef, {
            'uuid': socialUid,
            'firebaseUid': socialUid,
            'name': firebaseUser.displayName ?? '',
            'email': firebaseUser.email ?? '',
            'provider': 'google',
            'isGuest': false,
            'upgradedAt': FieldValue.serverTimestamp(),
          });
        }

        // messages 마이그레이션
        for (var doc in guestMessages ?? []) {
          final newRef = db.collection('users').doc(socialUid)
              .collection('messages').doc(doc.id);
          final existing = await newRef.get();
          if (!existing.exists) {
            batch.set(newRef, doc.data());
          }
        }

        // diaries 마이그레이션
        for (var doc in guestDiaries ?? []) {
          final newRef = db.collection('users').doc(socialUid)
              .collection('diaries').doc(doc.id);
          final existing = await newRef.get();
          if (!existing.exists) {
            batch.set(newRef, doc.data());
          }
        }

        // 비회원 문서 삭제
        if (previousGuestUid != socialUid) {
          batch.delete(db.collection('users').doc(previousGuestUid));
        }

        await batch.commit();
        print('✅ 마이그레이션 완료: $previousGuestUid → $socialUid');
        return userCredential;
      }

      // 4️⃣ 신규/기존 소셜 계정 처리
      final userDoc = db.collection('users').doc(socialUid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        print('🆕 신규 소셜 회원');
        await userDoc.set({
          'uuid': socialUid,
          'firebaseUid': socialUid,
          'name': firebaseUser.displayName ?? '',
          'email': firebaseUser.email ?? '',
          'provider': 'google',
          'isGuest': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        print('✅ 기존 소셜 회원 로그인');
      }

      return userCredential;

    } catch (e, stack) {
      print('🔴 [AuthRepo] signInWithGoogle 에러: $e');
      print(stack);
      rethrow;
    }
  }

  Future<UserCredential?> signinWIthApple() async {
    try {
      // final appleProvider = AppleAuthProvider();
      // return await _auth.signInWithProvider(appleProvider);
    }
    catch(e) {
      print('signInWithApple error: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signinWIthFacebook() async {
    try{
      // final facebookProvider = FacebookAuthProvider();
      // return await _auth.signInWithProvider(facebookProvider);
    }catch(e){
      print('signInWithFacebook error: $e');
      rethrow;
    }
  }

  @override
  Future<UserCredential?> guestLogin() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        await db.collection('users').doc(user.uid).set({
          'uuid': user.uid,
          'firebaseUid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'isGuest': true,
          'provider': 'guest',
        });
      }

      return userCredential;
    } catch (e) {
      print('guestLogin error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('signOut error: $e');
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    print(_auth.currentUser?.uid);
    return _auth.currentUser;
  }

  @override
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('getUserData error: $e');
      return null;
    }
  }

  @override
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await db.collection('users').doc(uid).set(
        data,
        SetOptions(merge: true),
      );
    } catch (e) {
      print('updateUserData error: $e');
      rethrow;
    }
  }

  @override
  Future<void> migrateGuestData({
    required String guestUid,
    required String socialUid,
  }) async {
    try{
      await _migrateCollection(
      guestUid: guestUid,
      socialUid: socialUid,
      collectionName: 'messages',
      );
      await _migrateCollection(
        guestUid: guestUid,
        socialUid: socialUid,
        collectionName: 'diaries',
      );

      // ✅ uid가 다를 때만 게스트 문서 삭제
      if (guestUid != socialUid) {
        await db.collection('users').doc(guestUid).delete();
        print('🗑️ 게스트 문서 삭제 완료: $guestUid');
      }

      print('✅ 전체 마이그레이션 완료: $guestUid → $socialUid');
    }catch(e){
      print('❌ migrateGuestData 실패: $e');
      rethrow;
    }
  }

  // 컬렉션 단위 마이그레이션 헬퍼
  Future<void> _migrateCollection({
    required String guestUid,
    required String socialUid,
    required String collectionName,
  }) async {
    final snapshot = await db
        .collection('users').doc(guestUid)
        .collection(collectionName).get();

    if (snapshot.docs.isEmpty) return;

    final batch = db.batch();
    for (var doc in snapshot.docs) {
      final newRef = db
          .collection('users').doc(socialUid)
          .collection(collectionName).doc(doc.id);
      batch.set(newRef, doc.data());
      batch.delete(doc.reference);
    }
    await batch.commit();
    print('✅ $collectionName 마이그레이션 완료 (${snapshot.docs.length}개)');
  }

  // FirebaseAuthRepository 구현
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('로그인 상태가 아닙니다');

      final uid = user.uid;

      // 하위 컬렉션 삭제
      await _deleteCollection(uid: uid, collectionName: 'messages');
      await _deleteCollection(uid: uid, collectionName: 'diaries');
      // Firestore 사용자 데이터 삭제
      await db.collection('users').doc(user.uid).delete();

      // Firebase Auth 계정 삭제
      await user.delete();
      // 구글 로그아웃
      await _googleSignIn.signOut();

      print('✅ 계정 삭제 완료');
    } catch (e) {
      print('❌ deleteAccount 실패: $e');
      rethrow;
    }
  }

  Future<void> _deleteCollection({
    required String uid,
    required String collectionName
}) async {
    final snapshot = await db
        .collection('users').doc(uid)
        .collection(collectionName).get();

    if (snapshot.docs.isEmpty) return;

    final batch = db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    print('🗑️ $collectionName 삭제 완료');
  }
}