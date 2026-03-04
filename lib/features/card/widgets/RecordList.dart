import 'package:flutter/material.dart';
import '../../../core/common/appColors.dart';
import '../model/card_record.dart';

class Recordlist extends StatelessWidget {
  final List<CardRecord> records;
  const Recordlist({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text('아직 상담 기록이 없어 🧸',
            style: TextStyle(fontSize: 13, color: AppColors.softBrown.withOpacity(0.6))),
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: records.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            // 날짜 배지
            Container(
              width: 42, padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bg, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(children: [
                Text('${r.date.month}월', style: TextStyle(
                  fontSize: 9, color: AppColors.softBrown.withOpacity(0.7), fontWeight: FontWeight.w500,
                )),
                Text('${r.date.day}', style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown, height: 1.1,
                )),
              ]),
            ),
            const SizedBox(width: 12),
            Text(r.card.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(r.card.name, style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.darkBrown,
                  )),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: r.card.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r.category, style: TextStyle(
                      fontSize: 10, color: r.card.color, fontWeight: FontWeight.w700,
                    )),
                  ),
                ]),
                const SizedBox(height: 3),
                Text(r.question, style: TextStyle(
                  fontSize: 11, color: AppColors.softBrown.withOpacity(0.8),
                ), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            )),
          ]),
        )).toList(),
      ),
    );
  }
}
