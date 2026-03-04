import 'package:flutter/material.dart';

// ── 타로 카드 덱 ───────────────────────────────────

class TarotCard {
  final String name;
  final String emoji;
  final String keyword;
  final String message;
  final String teddyComment;
  final Color color;

  const TarotCard({
    required this.name,
    required this.emoji,
    required this.keyword,
    required this.message,
    required this.teddyComment,
    required this.color,
  });
}
