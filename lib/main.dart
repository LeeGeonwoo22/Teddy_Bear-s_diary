import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teddyBear/features/auth/bloc/auth_bloc.dart';
import 'package:teddyBear/features/auth/login.dart';
import 'app.dart';
import 'features/chat/bloc/chat_bloc.dart';
import 'features/chat/chat.dart';
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
  runApp(
      MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>AuthBloc(),
        child: LoginPage(),),
        BlocProvider(create: (_)=>ChatBloc(),
        child: ChatbotFeature(),)

      ],
      child: App()));
}

