class Message {
  String msg;
  final MessageType msgType;
  final DateTime timestamp;

  Message({
    required this.msg,
    required this.msgType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

enum MessageType {user, bot}