
import 'package:go_router/go_router.dart';
import 'package:teddyBear/features/emotion/emotion_graph_5.dart';

import '../../features/card/card_page_3.dart';
import '../../features/chat/chatbot_page.dart';
import '../../features/auth/login_page.dart';
import '../../features/diary/diary_page.dart';
// import '../../features/emotion/emotion_graph.dart';
import '../../features/emotion/emotion_graph_2.dart';
import '../../features/emotion/emotion_graph_3.dart';
import '../../features/emotion/emotion_graph_4.dart';
import '../../features/settings/setting_page.dart';
import '../../features/splash/splash_page.dart';
import 'navbar/home_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        ShellRoute(builder:
        (context, state, child) {
          return HomeShell(child : child);
        }, routes: [
          GoRoute(
            path: '/chat',
            builder: (context, state) => ChatbotFeature(),
          ),
          GoRoute(
            path: '/diary',
            builder: (context, state) => DiaryPage(),
          ),
          GoRoute(
            path: '/emotion',
            builder: (context, state) => EmotionGraphPage_4(),
          ),
          GoRoute(
            path: '/card',
            builder: (context, state) => CardReadingPage_3(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => SettingsPage(),
          ),
        ]
        )
      ]);
}

