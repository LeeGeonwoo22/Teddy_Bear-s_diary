// import 'package:clouddb/clouddb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/common/global.dart';

abstract class AuthRepository {
  Future<UserCredential?> guestLogin();
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
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
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await initSignIn();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;

      GoogleSignInClientAuthorization? authorization =
      await authorizationClient.authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;

      if (accessToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(
              code: "no-access-token",
              message: "Failed to get access token"
          );
        }
        authorization = authorization2;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = db.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // 신규 소셜 가입
          await userDoc.set({
            'uuid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'provider': 'google',
            'isGuest': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          // 기존 비회원이 소셜로 전환하는 경우
          final data = docSnapshot.data();
          if (data?['isGuest'] == true) {
            await userDoc.update({
              'name': user.displayName ?? '',
              'email': user.email ?? '',
              'provider': 'google',
              'isGuest': false,
              'upgradedAt': FieldValue.serverTimestamp(),
            });
          }
        }
      }

      return userCredential;
    } catch (e) {
      print('signInWithGoogle error: $e');
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
    try {
      // 비회원 채팅 데이터 마이그레이션 예시
      final guestChatsQuery = await db
          .collection('chats')
          .where('userId', isEqualTo: guestUid)
          .get();

      // Batch로 일괄 처리
      final batch = db.batch();

      for (var doc in guestChatsQuery.docs) {
        // 새 문서 생성 (소셜 계정으로)
        final newDocRef = db.collection('chats').doc();
        batch.set(newDocRef, {
          ...doc.data(),
          'userId': socialUid,
          'migratedFrom': guestUid,
          'migratedAt': FieldValue.serverTimestamp(),
        });

        // 기존 비회원 데이터는 삭제 (선택사항)
        batch.delete(doc.reference);
      }

      await batch.commit();

      print('✅ 비회원 데이터 마이그레이션 완료: $guestUid -> $socialUid');
    } catch (e) {
      print('migrateGuestData error: $e');
      // 마이그레이션 실패해도 로그인은 계속 진행
    }
  }
}