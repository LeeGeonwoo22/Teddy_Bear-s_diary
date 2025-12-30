import '../../../data/model/message.dart';
import 'ChatRemoteDataSource.dart';
import 'chatLocalDataSource.dart';

class ChatRepository {
  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;

  ChatRepository({required this.remote, required this.local});

  Future<Message> sendMessage(String userMsg) async {
    // 1️⃣ 유저 메시지 저장
    final userMessage = Message(msg: userMsg, msgType: MessageType.user);
    await local.saveMessage(userMessage);

    // 2️⃣ API 호출
    final answer = await remote.fetchAnswer(userMsg);

    // 3️⃣ 봇 메시지 생성 + 저장
    final botMessage = Message(msg: answer, msgType: MessageType.bot);
    await local.saveMessage(botMessage);

    return botMessage;
  }
}
