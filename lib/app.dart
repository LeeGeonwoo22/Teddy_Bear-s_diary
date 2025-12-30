import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/route/app_router.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF5E2B8);
    return MaterialApp.router(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
        Locale('ja'),
      ],
      locale: Locale('ko'),
      routerConfig: AppRouter.router,
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