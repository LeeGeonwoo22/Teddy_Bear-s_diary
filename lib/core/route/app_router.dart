
import 'package:go_router/go_router.dart';
import '../../features/chat/chatbotFeature.dart';
import '../../features/auth/loginPage.dart';
import '../../features/diary/diary.dart';
import '../../features/settings/setting.dart';
import '../../features/splash/splash_page.dart';
import '../../features/to/toTeddy.dart';
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
            path: '/toTeddy',
            builder: (context, state) => Toteddy(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => SettingsPage(),
          ),
        ]
        )
      ]);
}

