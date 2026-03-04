import 'package:flutter/material.dart';

import '../../../core/common/appColors.dart';

class DeckIllust extends StatelessWidget {
  const DeckIllust({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 190,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(5, (i) => Transform.rotate(
              angle: (i - 2) * 0.07,
              child: Transform.translate(
                offset: Offset((i - 2) * 10.0, 0),
                child: Container(
                  width: 100, height: 148,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.2 + i * 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1.5),
                    boxShadow: [BoxShadow(
                      color: AppColors.brown.withOpacity(0.08),
                      blurRadius: 8, offset: const Offset(0, 4),
                    )],
                  ),
                  child: i == 4
                      ? const Center(child: Text('🧸', style: TextStyle(fontSize: 36)))
                      : null,
                ),
              ),
            )),
          ),
        ),
      );
    }
  }

