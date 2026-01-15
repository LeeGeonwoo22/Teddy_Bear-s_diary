class Diary {
  // final String id;           // 고유 ID
  // final String userId;       // 사용자 ID
  final DateTime date;       // 날짜
  final String title;        // 제목
  final String content;      // 본문
  final String emotion;      // 감정 (행복, 슬픔, 평온 등)
  // final List<String> chatIds; // 출처 채팅 ID들
  // final DateTime createdAt;  // 생성 시간

  Diary({
    required this.date,
    required this.title,
    required this.content,
    required this.emotion,
    // required this.id,
    // required this.userId,
    // required this.chatIds,
    // required this.createdAt,
  });

  // 위젯에서 사용 중인 Map 형태로 변환하는 도우미 메서드
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'content': content,
      'emotion': emotion,
    };
  }
}