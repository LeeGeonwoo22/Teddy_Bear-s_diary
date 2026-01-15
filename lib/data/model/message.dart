import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart'; // hive_ce 사용하는 경우
import 'package:uuid/uuid.dart';

part 'message.g.dart'; // build_runner가 자동 생성할 파일

@HiveType(typeId: 1) // ✅ enum은 위에 선언
enum MessageType {
  @HiveField(0)
  user,
  @HiveField(1)
  bot,
}

@HiveType(typeId: 0)
class Message extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String msg;

  @HiveField(2)
  final MessageType msgType;

  @HiveField(3)
  final DateTime timestamp;

  Message({
    String? id,
    required this.msg,
    required this.msgType,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Message copyWith({
    String? id,
    String? msg,
    MessageType? msgType,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      msg: msg ?? this.msg,
      msgType: msgType ?? this.msgType,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'msg': msg,
    'msgType': msgType.name,
    'timestamp': Timestamp.fromDate(timestamp),
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'] as String,
    msg: json['msg'] as String,
    msgType: MessageType.values.firstWhere(
          (e) => e.name == json['msgType'],
      orElse: () => MessageType.bot,
    ),
    timestamp: DateTime.parse(json['timestamp']),
  );

  @override
  String toString() =>
      'Message(id: $id, msgType: $msgType, msg: "${msg.length > 20 ? msg.substring(0, 20) + '...' : msg}", timestamp: $timestamp)';

  @override
  List<Object?> get props => [id, msg, msgType, timestamp];
}
