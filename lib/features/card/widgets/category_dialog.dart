import 'package:flutter/material.dart';

import '../../../core/common/appColors.dart';
import '../model/category.dart';

Future<void> showCategoryDialog(BuildContext context, {
  required void Function(CardCategory category) onSelected
})  {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.25),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: [BoxShadow(
            color: AppColors.brown.withOpacity(0.12),
            blurRadius: 20, offset: const Offset(0, 8),
          )],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 곰돌이 말풍선
            Row(children: [
              const Text('🧸', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 8),
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  '어떤 고민이 제일 마음에 걸려?',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBrown),
                ),
              )),
            ]),
            const SizedBox(height: 16),
            // 카테고리 리스트
            ...QCategories.map((category) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  onSelected(category);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    Text(category.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(category.name, style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkBrown,
                    )),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.softBrown.withOpacity(0.5)),
                  ]),
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}