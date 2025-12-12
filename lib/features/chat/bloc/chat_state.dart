
import '../../../data/model/message.dart';

class ChatState {
  final List<Message> messages;
  final bool isLoading;

  ChatState({
    required this.messages, this.isLoading = false,
});

  // ChatState에 messages와 isLoading값만 변경시킨다.
  ChatState copyWith({List<Message>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading
    );
}
  factory ChatState.initial() {
    return ChatState(messages: [
      Message(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
    ],
    );
  }
}
