
import '../../../core/common/date_utils.dart';
import '../../../data/model/diary.dart';

final Map<DateTime, Diary> dummyDiaries = {
  DateUtils.normalizeDate(DateTime.now()): Diary(

    date: DateTime.now(),
    title: "오늘의 Flutter 공부",
    content: "...",
    emotion: "🧸",
  ),

  DateUtils.normalizeDate(DateTime.now().subtract(const Duration(days: 1))): Diary(
    date: DateTime.now().subtract(const Duration(days: 1)),
    title: "맛있는 점심",
    content: "...",
    emotion: "🍝",
  ),
};

