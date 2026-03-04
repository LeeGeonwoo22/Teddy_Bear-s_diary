import 'package:flutter/material.dart';
import 'package:teddyBear/features/card/model/tarot_class.dart';

import '../../../core/common/appColors.dart';
import 'card_front.dart';

class RevealedCardPanel extends StatelessWidget {
  final TarotCard card;
  final Animation<Offset> slideAnim;
  const RevealedCardPanel({super.key, required this.card, required this.slideAnim});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          CardFront(card: card!),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: card!.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: card!.color.withOpacity(0.25)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(card!.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text('${card!.name} · ${card!.keyword}',
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkBrown,
                    )),
              ]),
              const SizedBox(height: 12),
              Text(card!.message, style: const TextStyle(
                fontSize: 14, color: AppColors.darkBrown, height: 1.7,
              )),
              Divider(height: 24, color: AppColors.border),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🧸 ', style: TextStyle(fontSize: 14)),
                Expanded(child: Text(card!.teddyComment, style: TextStyle(
                  fontSize: 13, color: AppColors.softBrown,
                  fontStyle: FontStyle.italic, height: 1.5,
                ))),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
