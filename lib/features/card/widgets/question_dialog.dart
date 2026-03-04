import 'package:flutter/material.dart';

import '../../../core/common/appColors.dart';
import '../model/category.dart';

Future<void> showQuestionDialog(BuildContext context,
{
  required CardCategory category,
  required TextEditingController etcController,
  required void Function(CardCategory category, String question) onSelected,
}){
  final questions = category.questions;
  final isEtc = category.isEtc;

  return     showDialog(
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
                child: Text(
                  isEtc ? '고민을 적어줘! Yes/No로 답할 수 있게 써줘 :)' : '어떤 부분이 궁금해?',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBrown),
                ),
              )),
            ]),
            const SizedBox(height: 16),

            if (isEtc) ...[
              // 텍스트 입력
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: etcController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: AppColors.darkBrown),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '예) 이 일을 계속하는 게 맞을까?',
                    hintStyle: TextStyle(fontSize: 12, color: AppColors.softBrown.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // 툴팁
              Row(children: [
                Icon(Icons.lightbulb_outline, size: 13, color: AppColors.gold),
                const SizedBox(width: 4),
                Expanded(child: Text(
                  'Yes / No로 답할 수 있도록 질문을 작성해주세요',
                  style: TextStyle(fontSize: 11, color: AppColors.softBrown.withOpacity(0.7)),
                )),
              ]),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  final q = etcController.text.trim();
                  if (q.isEmpty) return;
                  Navigator.pop(ctx);
                  onSelected(category, q);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.brown,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('확인', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14,
                  ))),
                ),
              ),
            ] else ...[
              // 질문 리스트
              ...questions.map((q) => GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  onSelected(category, q);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    Text('•  ', style: TextStyle(color: AppColors.softBrown, fontSize: 16)),
                    Expanded(child: Text(q, style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkBrown,
                    ))),
                  ]),
                ),
              )),
            ],
          ],
        ),
      ),
    ),
  );
}