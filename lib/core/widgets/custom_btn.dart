import 'package:flutter/material.dart';
import '../common/global.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData? icon; // 아이콘 추가 (선택사항)

  const CustomBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // 동화 감성 색상
        backgroundColor: Color(0xFFB89968), // 따뜻한 갈색 (#B89968)
        foregroundColor: Colors.white,

        // 더 둥근 모양
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),

        // 그림자 효과
        elevation: 4,
        shadowColor: Color(0xFF8B6F47).withOpacity(0.3),

        // 크기
        minimumSize: Size(mq.width * .4, 56),

        // 패딩
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            SizedBox(width: 10),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}