
import 'package:hive_ce/hive.dart';

import '../model/diary.dart';

class DiaryLocalSource {
  static const String _boxName = 'diaries';
  Box<Diary>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<Diary>(_boxName);
    print('📦 DiaryLocalSource 초기화 완료! Box 크기: ${_box!.length}');
  }

  Future<void> saveDiary(Diary diary) async {
    final key = _dateToKey(diary.date);
    await _box!.put(key, diary);
    print('💾 일기 저장 완료: $key');
  }

  Future<Diary?> getDiaryByDate(DateTime date) async {
    final key = _dateToKey(date);
    final diary = _box!.get(key);
    print('🔍 일기 조회: $key → ${diary != null ? "찾음" : "없음"}');
    return diary;
  }

  Future<Map<DateTime, Diary>> getAllDiaries() async {
    final Map<DateTime, Diary> diaries = {};

    for (var key in _box!.keys) {
      final diary = _box!.get(key);
      if (diary != null) {
        diaries[diary.date] = diary;
      }
    }

    print('📚 전체 일기 개수: ${diaries.length}');
    return diaries;
  }

  Future<void> deleteDiary(DateTime date) async {
    final key = _dateToKey(date);
    await _box!.delete(key);
    print('🗑️ 일기 삭제: $key');
  }

  Future<void> clearAll() async {
    await _box!.clear();
    print('🧹 전체 일기 삭제 완료!');
  }

  // ✅ 날짜 → 키 변환
  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}