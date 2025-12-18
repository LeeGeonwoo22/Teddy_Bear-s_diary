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
    if (location.startsWith('/journal')) currentIndex = 1;
    else if (location.startsWith('/memorial')) currentIndex = 2;
    else if (location.startsWith('/settings')) currentIndex = 3;


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
                context.go('/journal');
                break;
              case 2:
                context.go('/memorial');
                break;
              case 3:
                context.go('/settings');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.mood), label: '기분'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: '일기'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
    ));
  }
}
