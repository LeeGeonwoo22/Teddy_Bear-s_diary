class Diary {
  final String id;           // 서버 통신 시 필수
  final DateTime date;
  final String title;
  final String content;
  final String emotion;

  Diary({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.emotion,
  });

  // JSON → Diary 객체
  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      content: json['content'] as String,
      emotion: json['emotion'] as String,
    );
  }

  // Diary 객체 → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
      'emotion': emotion,
    };
  }

  // copyWith 메서드 (상태 업데이트 시 유용)
  Diary copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? content,
    String? emotion,
  }) {
    return Diary(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
    );
  }
}