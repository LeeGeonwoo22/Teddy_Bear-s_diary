import 'package:hive_ce/hive.dart';
import '../../../data/model/settings.dart';

class SettingRepository {
    // String _boxName = 'settings';
    static const String _key = 'app_settings';

    final Box<Settings> _box;

  // 🔹 생성자에서 box 주입 (권장 방식)
  SettingRepository(this._box);

  // 🔹 초기 설정 생성
  //  Future<SettingRepository> init() async {
    // final box = await Hive.openBox<Settings>(_boxName);

    // if (!box.containsKey(_key)) {
    //   final defaultSettings = Settings();
    //   await box.put(_key, defaultSettings);
    //   print('✅ 기본 설정 생성');
    // }
    //
    // return SettingRepository(box);
  // }

  // ✅ 설정 가져오기 (null 없음)
  Settings loadSettings() {
    return _box.get(_key)!;
  }

  // ✅ 전체 저장
  Future<void> saveSettings(Settings settings) async {
    await _box.put(_key, settings);
  }

  // ✅ 일기 생성 시간
  Future<void> saveDiaryCreationHour(int hour) async {
    final updated =
    loadSettings().copyWith(diaryCreationHour: hour);
    await saveSettings(updated);
  }

  // ✅ 일기 길이
  Future<void> saveDiaryLength(int length) async {
    final updated =
    loadSettings().copyWith(diaryLength: length);
    await saveSettings(updated);
  }

  // ✅ 알림
  Future<void> saveNotification(bool enabled) async {
    final updated =
    loadSettings().copyWith(notificationEnabled: enabled);
    await saveSettings(updated);
  }

  // ✅ 채팅 리마인더
  Future<void> saveChatReminder(bool enabled) async {
    final updated =
    loadSettings().copyWith(chatReminderEnabled: enabled);
    await saveSettings(updated);
  }

  // ✅ 테마
  Future<void> saveTheme(String theme) async {
    final updated =
    loadSettings().copyWith(theme: theme);
    await saveSettings(updated);
  }

  // ✅ 백업 날짜 업데이트
  Future<void> updateLastBackupDate(DateTime date) async {
    final updated =
    loadSettings().copyWith(lastBackupDate: date);
    await saveSettings(updated);
  }
}