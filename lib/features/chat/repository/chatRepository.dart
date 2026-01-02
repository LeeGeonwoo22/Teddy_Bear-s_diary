import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/model/message.dart';
import '../../auth/repository/AuthRepository.dart';
import 'chatRemoteDataSource.dart';
import 'chatLocalDataSource.dart';

class ChatRepository {
  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepository authRepository;

  ChatRepository({required this.remote, required this.local, required this.authRepository});

  String get _uid {
    final user = authRepository.getCurrentUser();
    if(user == null) {
      throw Exception('Not authenticated');
    }
    return user.uid;
  }

  Future<List<Message>> loadMessages({int limit =50}) async {
    try{
      final uid = _uid;
      final snapshot = await  _firestore
      .collection('users')
      .doc(uid)
      .collection('messages')
      .orderBy('timestamp', descending:  false)
      .limit(limit)
      .get();
      final messages = snapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();

    // 2️⃣ 로컬 캐시 업데이트 (선택사항)
    for (var message in messages) {
    await local.saveMessage(message);
    }

    print('✅ 메시지 불러오기 완료: ${messages.length}개');
    return messages;

    }catch(e) {
      print('❌ 메시지 불러오기 실패: $e');
      try {
        final cachedMessages = await local.getAllMessages();
        print('⚠️ 로컬 캐시에서 불러옴: ${cachedMessages.length}개');
        return cachedMessages;
      } catch (e2) {
        print('❌ 로컬 캐시도 실패: $e2');
        return [];
      }
    }
  }

  Future<Message> sendMessage(String userMsg) async {
    final uid = _uid;
    // 1️⃣ 유저 메시지 저장
    final userMessage = Message(msg: userMsg, msgType: MessageType.user);
    await local.saveMessage(userMessage);

    // 2️⃣ Firestore 저장
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('messages')
        .doc(userMessage.id)
        .set(userMessage.toJson());
    final answer = await remote.fetchAnswer(userMsg);

    final botMessage = Message(msg: answer, msgType: MessageType.bot);
    await local.saveMessage(botMessage);
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('messages')
        .doc(botMessage.id)
        .set(botMessage.toJson());

    return botMessage;
  }

  // ✅ 모든 메시지 삭제 (추가)
  Future<void> deleteAllMessages() async {
    try {
      final uid = _uid;

      // 1️⃣ Firestore 삭제
      final batch = _firestore.batch();
      final messages = await _firestore
          .collection('users')
          .doc(uid)
          .collection('messages')
          .get();

      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // 2️⃣ 로컬 캐시 삭제
      await local.clearAllMessages();

      print('✅ 모든 메시지 삭제 완료');

    } catch (e) {
      print('❌ 메시지 삭제 실패: $e');
      rethrow;
    }
  }
}
