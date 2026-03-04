import 'package:flutter/material.dart';

import '../../../core/common/appColors.dart';
import '../model/category.dart';

class QuestionBadge extends StatelessWidget {
  final CardCategory category;
  final String question;

  const QuestionBadge({super.key, required this.category, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Text(category.emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(
          question,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        )),
      ]),
    );
  }
}
