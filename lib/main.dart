import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:teddyBear/features/auth/bloc/auth_bloc.dart';
import 'package:teddyBear/features/chat/repository/chatRepository.dart';
import 'package:teddyBear/dependencyContainer.dart';
import 'app.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/repository/AuthRepository.dart';
import 'features/chat/bloc/chat_bloc.dart';
import 'features/chat/repository/ChatRemoteDataSource.dart';
import 'features/chat/repository/chatLocalDataSource.dart';
import 'firebase_options.dart';

void main() async{
  // Flutter 엔진과 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();
  // dotenv
  await dotenv.load(fileName: "assets/.env");
  // 화면 방향 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 초기화 완료
  await DependencyContainer.setupLocator();
  // final AuthRepository _authRepository = FirebaseAuthRepository();
  // final http.Client client = http.Client();
  // final ChatRemoteDataSource remote = ChatRemoteDataSource(client);
  // final ChatLocalDataSource local = ChatLocalDataSource();
  // final ChatRepository _chatRepository = ChatRepository(remote: remote, local: local);
  runApp(
      MultiBlocProvider(
      providers: [
        // authbloc 형성과 동시에 appStarted 이벤트발생
        BlocProvider<AuthBloc>(create: (_)=>AuthBloc(DependencyContainer.injector.get<AuthRepository>())..add(const AppStarted()),
        ),
        BlocProvider<ChatBloc>(create: (_)=>ChatBloc(DependencyContainer.injector.get<ChatRepository>()),
        )

      ],
      child: App()));
}

