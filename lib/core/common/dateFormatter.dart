
class DateFormatter {
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // ✅ 추가: 여러 포맷 지원
  static String formatDateKorean(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  static String formatDateDot(DateTime date) {
    return '${date.year}.${date.month}.${date.day}';
  }
}