import 'package:hive_ce/hive.dart';
import 'package:equatable/equatable.dart';

part 'diary.g.dart'; // ⚠️ build_runner가 생성할 파일

@HiveType(typeId: 2) // ⚠️ Message가 typeId: 0,1 사용 중이면 2로
class Diary extends HiveObject with EquatableMixin {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String emotion;

  Diary({
    required this.date,
    required this.title,
    required this.content,
    required this.emotion,
  });

  // ✅ copyWith (수정용)
  Diary copyWith({
    DateTime? date,
    String? title,
    String? content,
    String? emotion,
  }) {
    return Diary(
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
    );
  }

  @override
  List<Object?> get props => [date, title, content, emotion];

  @override
  String toString() => 'Diary(date: $date, title: $title, emotion: $emotion)';
}