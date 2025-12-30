// dependencyContainer.dart

import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:teddyBear/features/auth/repository/AuthRepository.dart';
import 'package:teddyBear/features/chat/repository/ChatRemoteDataSource.dart';
import 'package:teddyBear/features/chat/repository/chatLocalDataSource.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';

class DependencyContainer {
  static final injector = GetIt.instance;

  static Future<void> setupLocator() async {
    // ✅ Hive 초기화 - 한 번만!
    await Hive.initFlutter();

    // ✅ http client
    injector.registerLazySingleton<http.Client>(
          () => http.Client(),
      dispose: (client) => client.close(),
    );

    // ✅ local dataSource - 초기화와 함께 등록
    injector.registerLazySingletonAsync<ChatLocalDataSource>(() async {
      final dataSource = ChatLocalDataSource();
      await dataSource.init();
      return dataSource;
    }, dispose: (dataSource) => dataSource.dispose());

    // ✅ local dataSource가 준비될 때까지 대기
    await injector.isReady<ChatLocalDataSource>();

    // ✅ remote dataSource
    injector.registerLazySingleton(
          () => ChatRemoteDataSource(injector<http.Client>()),
    );

    // ✅ chat repository
    injector.registerLazySingleton(
          () => ChatRepository(
        remote: injector<ChatRemoteDataSource>(),
        local: injector<ChatLocalDataSource>(),
      ),
    );

    // ✅ auth repository
    injector.registerLazySingleton<AuthRepository>(
          () => FirebaseAuthRepository(),
    );
  }
}