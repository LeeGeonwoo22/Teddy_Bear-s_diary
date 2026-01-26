// data/models/settings.dart

import 'package:hive_ce/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings extends HiveObject {
  // ===== 일기 설정 =====
  @HiveField(0)
  int diaryCreationHour;

  @HiveField(1)
  int diaryLength; // 0: 짧게(200자), 1: 보통(300자), 2: 길게(500자)

  // ===== 알림 설정 =====
  @HiveField(2)
  bool notificationEnabled;

  @HiveField(3)
  bool chatReminderEnabled;

  // ===== 테마 설정 =====
  @HiveField(4)
  String theme; // 'light', 'dark', 'system'

  // ===== 기타 =====
  @HiveField(5)
  DateTime? lastBackupDate;

  Settings({
    this.diaryCreationHour = 23,
    this.diaryLength = 1, // 기본 보통
    this.notificationEnabled = true,
    this.chatReminderEnabled = false,
    this.theme = 'light',
    this.lastBackupDate,
  });

  // 🔑 copyWith (설정 수정 시 편리)
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
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      chatReminderEnabled: chatReminderEnabled ?? this.chatReminderEnabled,
      theme: theme ?? this.theme,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }
}