
import 'package:go_router/go_router.dart';
import '../../features/chat/chat.dart';
import '../../features/home/home_shell.dart';
import '../../features/auth/login.dart';
import '../../features/splash/splash_page.dart';

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
        GoRoute(
          path: '/settings',
          builder: (context, state) => ChatbotFeature(),
        ),
        ShellRoute(builder:
        (context, state, child) {
          return HomeShell(child : child);
        }, routes: [
          GoRoute(
            path: '/chat',
            builder: (context, state) => ChatbotFeature(),
          ),
          // GoRoute(
          //   path: '/home',
          //   builder: (context, state) => HomePage(),
          // ),
          // GoRoute(
          //   path: '/album',
          //   builder: (context, state) => HomePage(),
          // ),
          // GoRoute(
          //   path: '/journal',
          //   builder: (context, state) => HomePage(),
          // ),
          // GoRoute(
          //   path: '/mood',
          //   builder: (context, state) => HomePage(),
          // ),
        ]
        )
      ]);
}

