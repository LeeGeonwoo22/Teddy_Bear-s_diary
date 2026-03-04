import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/diary')) currentIndex = 1;
    else if (location.startsWith('/emotion')) currentIndex = 2;
    else if (location.startsWith('/card')) currentIndex = 3;
    else if (location.startsWith('/setting')) currentIndex = 4;


    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: navTheme.backgroundColor ?? theme.colorScheme.surface,
          selectedItemColor: navTheme.selectedItemColor ?? theme.colorScheme.primary,
          unselectedItemColor:
          navTheme.unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6),
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/chat');
                break;
              case 1:
                context.go('/diary');
                break;
              case 2:
                context.go('/emotion');
                break;
              case 3:
                context.go('/card');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '이야기'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: '일기'),
            BottomNavigationBarItem(icon: Icon(Icons.mood), label: '감정 그래프'),
            BottomNavigationBarItem(icon: Icon(Icons.star_outlined), label: '조언 카드'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
    ));
  }
}
