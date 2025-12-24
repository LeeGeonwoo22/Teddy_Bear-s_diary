import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teddyBear/features/auth/bloc/auth_bloc.dart';
import 'app.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/repository/AuthRepository.dart';
import 'features/chat/bloc/chat_bloc.dart';
import 'firebase_options.dart';

void main() async{
  await dotenv.load(fileName: "assets/.env");
  // 화면 방향 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final AuthRepository _authRepository = FirebaseAuthRepository();

  runApp(
      MultiBlocProvider(
      providers: [
        // authbloc 형성과 동시에 appStarted 이벤트발생
        BlocProvider<AuthBloc>(create: (_)=>AuthBloc(_authRepository)..add(const AppStarted()),
        ),
        BlocProvider<ChatBloc>(create: (_)=>ChatBloc(),
        )

      ],
      child: App()));
}

