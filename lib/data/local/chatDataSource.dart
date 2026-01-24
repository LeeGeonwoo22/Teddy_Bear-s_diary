// chat_local_data_source.dart

import 'package:hive_ce/hive.dart';
import '../../../../data/model/message.dart';

class ChatLocalSource {
  static const boxName = 'chat_messages';
  Box<Message>? _box;

  // ✅ 초기화 - Adapter 등록 및 Box 열기
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(MessageAdapter().typeId)) {
      Hive.registerAdapter(MessageAdapter());
    }
    _box = await Hive.openBox<Message>(boxName);
  }

  // ✅ Box getter - 안전하게 접근
  Box<Message> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('ChatLocalDataSource not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> saveMessage(Message msg) async {
    await box.add(msg);
  }

  /// 기간별 메시지 조회
  Future<List<Message>> getMessagesBetween(DateTime start, DateTime end) async {
    final messages = _box!.values.where((msg) {
      return msg.timestamp.isAfter(start.subtract(const Duration(seconds: 1))) &&
          msg.timestamp.isBefore(end);
    }).toList();

    // 시간순 정렬
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    print('🔍 ${start.month}/${start.day} ~ ${end.month}/${end.day} 메시지: ${messages.length}개');
    return messages;
  }

  Future<List<Message>> getMessages() async {
    return box.values.toList();
  }

  Future<void> clearAllMessages() async {
    await box.clear();
  }

  // ✅ 리소스 정리
  Future<void> dispose() async {
    await _box?.close();
  }

  Future<dynamic> getAllMessages() async {
    await _box!;
  }
}