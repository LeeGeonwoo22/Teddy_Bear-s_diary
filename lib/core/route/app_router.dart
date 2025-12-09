
import 'package:go_router/go_router.dart';
import '../../auth/phone.dart';
import '../../features/chat/chat.dart';
import '../../features/home/home.dart';
import '../../features/login/login.dart';
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
}
