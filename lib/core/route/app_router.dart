
import 'package:go_router/go_router.dart';
import '../../features/chat/chat.dart';
import '../../features/auth/login.dart';
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
          // GoRoute(
          //   path: '/journal',
          //   builder: (context, state) => HomePage(),
          // ),
          // GoRoute(
          //   path: '/album',
          //   builder: (context, state) => HomePage(),
          // ),
          // GoRoute(
          //   path: '/settings',
          //   builder: (context, state) => HomePage(),
          // ),
        ]
        )
      ]);
}

