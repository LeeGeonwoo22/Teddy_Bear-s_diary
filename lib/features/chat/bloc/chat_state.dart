
import 'package:equatable/equatable.dart';

import '../../../data/model/message.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final String searchQuery;
  final bool isLoading;

  const ChatState({
    required this.messages,
    this.searchQuery = '',
    this.isLoading = false,
  });

  // ✅ 검색 필터링된 메시지 (Getter)
  List<Message> get filteredMessages {
    if (searchQuery.isEmpty) return messages;
    return messages
        .where((msg) => msg.msg.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  List<Object?> get props => [messages, searchQuery, isLoading];

  ChatState copyWith({
    List<Message>? messages,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ChatState.initial() {
    return ChatState(
      messages: [
        Message(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
      ],
    );
  }
}

