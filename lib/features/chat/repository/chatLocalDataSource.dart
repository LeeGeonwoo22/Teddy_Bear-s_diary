// chat_local_data_source.dart

import 'package:hive_ce/hive.dart';
import '../../../data/model/message.dart';

class ChatLocalDataSource {
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

  Future<List<Message>> getMessages() async {
    return box.values.toList();
  }

  Future<void> clearAll() async {
    await box.clear();
  }

  // ✅ 리소스 정리
  Future<void> dispose() async {
    await _box?.close();
  }
}