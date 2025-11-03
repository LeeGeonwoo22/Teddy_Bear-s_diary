import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth/phone.dart';
import 'features/chat/chat.dart';
import 'features/home/home.dart';
import 'features/login/login.dart';
import 'features/splash/splash_page.dart';
import 'firebase_options.dart';

void main() async{
  runApp( MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => SplashPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => ChatbotFeature(),
        ),
        GoRoute(
          path: '/phone-login',
          builder: (context, state) => PhoneLoginScreen(),
        ),
  ]);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF5E2B8);
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: "Teddy Bear's diary",
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor, // 전체 배경색 지정
        colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor),
        useMaterial3: true,
      ),
    );
  }
}