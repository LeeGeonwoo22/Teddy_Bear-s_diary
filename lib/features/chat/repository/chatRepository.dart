import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/common/encryption_service.dart';
import '../../../data/local/chatDataSource.dart';
import '../../../data/model/message.dart';
import '../../auth/repository/AuthRepository.dart';
import '../../../core/common/aIService.dart';

class ChatRepository {
  final AIService remote;
  final ChatLocalSource local;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final AuthRepository authRepository;
  final EncryptionService _encryption = EncryptionService();

  ChatRepository({
    required this.remote,
    required this.local,
    required this.authRepository,
  });

  String get _uid {
    final user = authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('Not authenticated');
    }
    return user.uid;
  }

  /// 메시지 불러오기
  Future<List<Message>> loadMessages({int? limit = 50}) async {
    try {
      final uid = _uid;
      // final targetMessageId = messageId ?? _currentMessageId;

      print('📥 메시지 불러오는 중: $int');
      // 개별 문서 쿼리
      final snapshot = await db
          .collection('users')
          .doc(uid)
          .collection('messages')
          .orderBy('timestamp', descending : false)
          .limit(limit!)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();

        print('🔍 데이터 타입 확인:');
        print('  msg: ${data['msg'].runtimeType} = ${data['msg']}');
        print('  timestamp: ${data['timestamp'].runtimeType}');
      }

      // 🔓 복호화
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();
        final rawMsg = data['msg'];
        late final String decryptedMsg;
        if (rawMsg == null) {
          // ❌ msg 자체가 없는 경우
          decryptedMsg = '';
        }
        else if (rawMsg is String) {
          // 🔙 과거 평문 메시지
          decryptedMsg = rawMsg;
        }
        else if (rawMsg is Map<String, dynamic>) {
          // ✅ 암호화 메시지
          decryptedMsg = _encryption.decrypt(
            cipherText: rawMsg['cipher'],
            ivBase64: rawMsg['iv'],
          );
        }
        else {
          // 🚨 예상 못한 타입
          decryptedMsg = '';
        }
        return Message(
          id: data['id'],
          msg: decryptedMsg,
          msgType: MessageType.values.byName(data['msgType']),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();

      print('✅ Firestore에서 ${messages.length}개 메시지 불러옴 (복호화 완료)');

      // 로컬 캐시 업데이트
      await local.clearAllMessages();
      for (var message in messages) {
        await local.saveMessage(message);
      }
      return messages;
    } catch (e, stackTrace) {
      print('❌ Firestore 실패: $e');
      print('위치: $stackTrace'); // ← 어디서 에러났는지 확인
      // 로컬 캐시에서 복구
      try{
        final cachedMessages = await local.getMessages();
        print('⚠️ 로컬 캐시: ${cachedMessages.length}개');
        return cachedMessages;
      }catch(e2){
        print('❌ 로컬 캐시도 실패: $e2');
        return [];
      }

    }
  }

  /// 메시지 전송
  Future<Message> sendMessage(String userMsg) async {

    try{
      // 🔐 암호화 초기화
      final uid = _uid;

      // 사용자 메세지 생성
      final userMessage =
      Message(msg: userMsg, msgType: MessageType.user);
      // 유저 메세지 로칼 저장
      await local.saveMessage(userMessage);
      // 암호화
      final encryptedUserMsg = _encryption.encrypt(userMsg);
      // 암호화 반환값 테스트
      final encryptedData = _encryption.encrypt('테스트');
      print('🔍 encrypt 반환 타입: ${encryptedData.runtimeType}');
      print('🔍 encrypt 반환 값: $encryptedData');
      print('📤 사용자 메시지 저장 완료 (암호화됨)');

      await db.collection('users')
          .doc(uid).collection('messages')
          .doc(userMessage.id)
          .set({
            'id' : userMessage.id,
            'msg' : encryptedUserMsg,
            'msgType' : userMessage.msgType.name,
            'timestamp' : Timestamp.fromDate(userMessage.timestamp)
      });


      // 2️⃣ AI API 응답
      final answer = await remote.fetchAnswer(userMsg);
      // bot 메세지 생성
      final botMessage =
      Message(msg: answer, msgType: MessageType.bot);
      await local.saveMessage(botMessage);
      // 메세지 암호화
      final encryptedBotMsg = _encryption.encrypt(answer);

      await db.collection('users').doc(uid).collection('messages').doc(botMessage.id).set({
        'id' : botMessage.id,
        'msg' : encryptedBotMsg,
        'msgType' : botMessage.msgType.name,
        'timestamp' : Timestamp.fromDate(botMessage.timestamp)
      });

      print('📥 봇 응답 저장 완료 (암호화됨)');
      print('✅ 메시지 전송 완료!');
      return botMessage;

    }catch(e) {
      print('❌ sendMessage 실패: $e');
      rethrow;
    }
  }

  /// 모든 메시지 삭제
  Future<void> deleteAllMessages() async {
    try {
      final uid = _uid;
      final batch = db.batch();

      // Firestore의 모든 메시지 문서 조회
      final messageDocs = await db
          .collection('users')
          .doc(uid)
          .collection('messages')
          .get();

      // Batch 삭제
      for (var doc in messageDocs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      await local.clearAllMessages();

      print('🗑️ 모든 메시지 삭제 완료');

    } catch (e) {
      print('❌ 메시지 삭제 실패: $e');
      rethrow;
    }
  }

  /// 오늘의 메시지 가져오기
  Future<List<Message>> getTodayMessages() async {
    print('📅 오늘의 대화 가져오기');

    final messages = await local.getMessages();

    print('✅ 오늘의 대화 개수: ${messages.length}개');

    return messages;
  }

  // ========== 헬퍼 메서드 ==========

  /// Timestamp 안전하게 파싱
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }

  /// MessageType 안전하게 파싱
  MessageType _parseMessageType(dynamic type) {
    if (type == null) return MessageType.user;

    final typeStr = type.toString().toLowerCase();

    switch (typeStr) {
      case 'bot':
        return MessageType.bot;
      case 'user':
        return MessageType.user;
      default:
        return MessageType.user;
    }
  }

  /// 로컬 캐시 업데이트
  Future<void> _updateLocalCache(List<Message> messages) async {
    await local.clearAllMessages();

    for (var message in messages) {
      await local.saveMessage(message);
    }
  }

  /// 로컬 캐시에서 메시지 불러오기
  Future<List<Message>> _loadFromLocalCache() async {
    try {
      final cachedMessages = await local.getMessages();
      print('⚠️ 로컬 캐시에서 복구: ${cachedMessages.length}개');
      return cachedMessages;

    } catch (e) {
      print('❌ 로컬 캐시도 실패: $e');
      return [];
    }
  }
}