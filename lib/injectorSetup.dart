// injectorSetup.dart

import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:teddyBear/features/auth/repository/AuthRepository.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import 'data/local/chatDataSource.dart';
import 'data/local/diaryDataSource.dart';
import 'data/model/diary.dart';
import 'data/model/message.dart';
import 'core/common/aIService.dart';
import 'data/model/settings.dart';
import 'features/diary/repository/diaryRepository.dart';
import 'features/settings/repository/settingRepository.dart';

class InjectorSetup {
  static final injector = GetIt.instance;

  static Future<void> setupLocator() async {
    // print('🔧 DI 설정 시작...');

    // ✅ Hive 초기화 - 한 번만!
    await Hive.initFlutter();
    // print('🔧 hive 초기화 완료...');
    Hive.registerAdapter(MessageTypeAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(DiaryAdapter());
    Hive.registerAdapter(SettingsAdapter());

    final settingsBox = await Hive.openBox<Settings>('settings');

    if (!settingsBox.containsKey('app_settings')) {
      await settingsBox.put('app_settings', Settings());
    }

    // ✅ http client
    injector.registerLazySingleton<http.Client>(
          () => http.Client(),
      dispose: (client) => client.close(),
    );
    // print('✅ HTTP Client 등록');

    injector.registerLazySingleton<AuthRepository>(
          () => FirebaseAuthRepository(),
    );
    /*print('✅ AuthRepository 등록');*/

    // ✅ local dataSource - 초기화와 함께 등록
    injector.registerLazySingletonAsync<ChatLocalSource>(() async {
      final dataSource = ChatLocalSource();
      await dataSource.init();
      return dataSource;
    }, dispose: (dataSource) => dataSource.dispose());

    // ✅ local dataSource가 준비될 때까지 대기
    await injector.isReady<ChatLocalSource>();

    injector.registerLazySingletonAsync<DiaryLocalSource>(() async {
      final dataSource = DiaryLocalSource();
      await dataSource.init();
      return dataSource;
    });

    await injector.isReady<DiaryLocalSource>();

    // ✅ remote dataSource
    injector.registerLazySingleton(
          () => AIService(injector<http.Client>()),
    );

    // ✅ chat repository
    injector.registerLazySingleton(
          () => ChatRepository(
        remote: injector<AIService>(),
        local: injector<ChatLocalSource>(),
            authRepository:injector<AuthRepository>(),
      ),
    );

// DiaryRepository 등록 부분 - 파라미터 수정
    injector.registerLazySingleton(
          () => DiaryRepository(
        remote: injector<AIService>(),
        local: injector<DiaryLocalSource>(),  // ✅ DiaryLocalSource로 수정!
        chatRepository: injector<ChatRepository>(), authRepository: injector<AuthRepository>(),  // ✅ ChatRepository로 수정!
      ),
    );
    injector.registerLazySingleton<SettingRepository>(
          () => SettingRepository(settingsBox),
    );
  }
}