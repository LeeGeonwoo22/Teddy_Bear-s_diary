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
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,  // 👈 모든 AppBar의 텍스트/아이콘 색상
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF8B6F47),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor),
        useMaterial3: true,
      ),
    );
  }
}