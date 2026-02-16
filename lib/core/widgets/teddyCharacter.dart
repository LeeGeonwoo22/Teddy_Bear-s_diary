// lib/features/common/widgets/teddy_character.dart
import 'package:flutter/material.dart';

class TeddyCharacter extends StatelessWidget {
  final double size;
  final String emoji;

  const TeddyCharacter({
    super.key,
    this.size = 80,
    this.emoji = '🧸',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -5 * (1 - value)),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4C4),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: size * 0.6)),
            ),
          ),
        );
      },
    );
  }
}