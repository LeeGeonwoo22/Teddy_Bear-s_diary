import 'package:flutter/material.dart';

import '../../../core/common/appColors.dart';
import '../model/tarot_class.dart';

class CardFront extends StatelessWidget {
  final TarotCard card;

   CardFront({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: 140, height: 210,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: card!.color.withOpacity(0.6), width: 2),
          boxShadow: [BoxShadow(
            color: card!.color.withOpacity(0.22),
            blurRadius: 20, offset: const Offset(0, 8),
          )],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(card!.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(card!.name, style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.darkBrown,
          )),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: card!.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(card!.keyword, style: TextStyle(
              fontSize: 11, color: card!.color, fontWeight: FontWeight.w700,
            )),
          ),
        ]),
      );
    }
  }
