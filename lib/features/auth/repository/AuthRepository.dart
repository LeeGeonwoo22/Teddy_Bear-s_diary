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
    print('🟡 [AuthRepo] signInWithGoogle 시작');
    print('🟡 [Repo] 받은 previousGuestUid: $previousGuestUid');

    try {
      // 1️⃣ 구글 로그인 인증 과정
      await initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      print('✅ googleUser: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      print('   idToken: ${googleAuth.idToken != null}');

      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization =
      await authorizationClient.authorizationForScopes(['email', 'profile']);

      // accessToken 재시도 로직
      if (authorization?.accessToken == null) {
        print('⚠️ accessToken null → 재시도');
        authorization = await authorizationClient.authorizationForScopes(['email', 'profile']);

        if (authorization?.accessToken == null) {
          throw FirebaseAuthException(
            code: "no-access-token",
            message: "Failed to get access token",
          );
        }
      }

      // 2️⃣ Firebase 인증
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null');
      }

      print('✅ Firebase user uid: ${firebaseUser.uid}');
      print('   providerData: ${firebaseUser.providerData.map((e) => e.providerId)}');

      // 3️⃣ 비회원 → 구글 전환 처리
      if (previousGuestUid != null) {
        final guestDoc = db.collection('users').doc(previousGuestUid);
        final guestSnapshot = await guestDoc.get();
        final guestData = guestSnapshot.data();

        print('📄 비회원 문서 존재: ${guestSnapshot.exists}');
        print('📄 비회원 문서 ID: $previousGuestUid');
        print('📄 비회원 데이터: $guestData');

        if (guestData != null && guestData['isGuest'] == true) {
          print('🔄 Guest → Google 전환');

          // 👇 비회원 문서를 그대로 업데이트
          await guestDoc.update({
            'name': firebaseUser.displayName ?? guestData['name'] ?? '',
            'email': firebaseUser.email ?? guestData['email'] ?? '',
            'provider': 'google',
            'isGuest': false,
            'upgradedAt': FieldValue.serverTimestamp(),
          });
          await migrateGuestData(
            guestUid: previousGuestUid,
            socialUid: firebaseUser.uid,
          );

          print('✅ 비회원 문서 업데이트 완료: $previousGuestUid');
          print('🟢 [AuthRepo] signInWithGoogle 정상 종료 (전환)');
          return userCredential;
        }
      }

      // 4️⃣ 신규 소셜 계정 또는 기존 소셜 계정 처리
      final userDoc = db.collection('users').doc(firebaseUser.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        print('🆕 신규 소셜 회원');
        await userDoc.set({
          'uuid': firebaseUser.uid,
          'firebaseUid': firebaseUser.uid,
          'name': firebaseUser.displayName ?? '',
          'email': firebaseUser.email ?? '',
          'provider': 'google',
          'isGuest': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        print('✅ 기존 소셜 회원 로그인');
      }

      print('🟢 [AuthRepo] signInWithGoogle 정상 종료');
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