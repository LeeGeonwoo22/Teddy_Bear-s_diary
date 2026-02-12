// features/settings/repository/SettingRepository.dart

import 'package:hive_ce/hive.dart';
import '../../../data/model/settings.dart';

class SettingRepository {
  static const String _boxName = 'settings';
  static const String _key = 'app_settings';
  static Box<Settings>? _box;

  /// 초기화 (main.dart에서 호출 필수!)
  static Future<void> init() async {
    _box = await Hive.openBox<Settings>(_boxName);
    print('⚙️ SettingRepository 초기화 완료');

    // ✅ Box가 비어있으면 기본값 생성
    if (_box!.isEmpty) {
      final defaultSettings = Settings();
      await _box!.put(_key, defaultSettings);
      print('✅ 기본 설정 생성: ${defaultSettings.diaryCreationHour}시');
    }
  }

  /// 설정 가져오기
  static Settings? getSettings() {
    print('🔍 getSettings 호출');

    if (_box == null) {
      print('❌ Box가 null! init()를 먼저 호출하세요!');
      return null;
    }

    final settings = _box!.get(_key);

    if (settings == null) {
      print('⚠️ 설정이 없음. 기본값 생성');
      final defaultSettings = Settings();
      _box!.put(_key, defaultSettings);
      return defaultSettings;
    }

    print('✅ 설정 로드: ${settings.diaryCreationHour}시');
    return settings;
  }

  /// 설정 저장
  static Future<void> saveSettings(Settings settings) async {
    await _box!.put(_key, settings);
    print('💾 설정 저장: ${settings.diaryCreationHour}시');
  }

  /// 특정 필드만 업데이트
  static Future<void> setDiaryCreationHour(int hour) async {
    final settings = getSettings() ?? Settings();
    settings.diaryCreationHour = hour;
    await saveSettings(settings);
  }

  static Future<void> setDiaryLength(int length) async {
    final settings = getSettings() ?? Settings();
    settings.diaryLength = length;
    await saveSettings(settings);
  }

  static Future<void> setNotificationEnabled(bool enabled) async {
    final settings = getSettings() ?? Settings();
    settings.notificationEnabled = enabled;
    await saveSettings(settings);
  }
}