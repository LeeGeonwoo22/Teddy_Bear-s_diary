import 'package:flutter/material.dart';

import '../../../core/common/appColors.dart';

// ✅ 올바른 방식 — 애니메이션을 외부에서 받음
class CardBack extends StatelessWidget {
  final Animation<double> floatAnim;

  const CardBack({super.key, required this.floatAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, height: 210,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withOpacity(0.5), AppColors.softBrown.withOpacity(0.35)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [BoxShadow(color: AppColors.brown.withOpacity(0.18), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        AnimatedBuilder(
          animation: floatAnim,
          builder: (ctx, child) =>
              Transform.translate(offset: Offset(0, floatAnim.value * 0.4), child: child),
          child: const Text('🧸', style: TextStyle(fontSize: 44)),
        ),
        const SizedBox(height: 8),
        Text('TOUCH', style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w800,
          color: AppColors.brown.withOpacity(0.55), letterSpacing: 3,
        )),
      ]),
    );
  }
}
