import 'package:hive_ce/hive.dart';
import 'package:flutter/material.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings extends HiveObject {

  // ===== 일기 설정 =====
  @HiveField(0)
  final int diaryCreationHour;

  @HiveField(1)
  final int diaryLength; // 0: 짧게, 1: 보통, 2: 길게

  // ===== 알림 설정 =====
  @HiveField(2)
  final bool notificationEnabled;

  @HiveField(3)
  final bool chatReminderEnabled;

  // ===== 테마 설정 =====
  @HiveField(4)
  final String theme; // 저장은 문자열로 유지

  // ===== 기타 =====
  @HiveField(5)
  final DateTime? lastBackupDate;

   Settings({
    this.diaryCreationHour = 23,
    this.diaryLength = 1,
    this.notificationEnabled = true,
    this.chatReminderEnabled = false,
    this.theme = 'light',
    this.lastBackupDate,
  });

  // 🔑 copyWith
  Settings copyWith({
    int? diaryCreationHour,
    int? diaryLength,
    bool? notificationEnabled,
    bool? chatReminderEnabled,
    String? theme,
    DateTime? lastBackupDate,
  }) {
    return Settings(
      diaryCreationHour: diaryCreationHour ?? this.diaryCreationHour,
      diaryLength: diaryLength ?? this.diaryLength,
      notificationEnabled:
      notificationEnabled ?? this.notificationEnabled,
      chatReminderEnabled:
      chatReminderEnabled ?? this.chatReminderEnabled,
      theme: theme ?? this.theme,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }

  // 🔄 ThemeMode 변환 getter
  ThemeMode get themeMode {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  // 🔄 ThemeMode 저장용 변환
  static String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'light';
    }
  }
}