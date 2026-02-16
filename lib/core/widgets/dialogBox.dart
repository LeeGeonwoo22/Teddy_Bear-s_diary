import 'package:flutter/material.dart';

import '../common/dialogueController.dart';

class DialogueBox extends StatelessWidget {
  final DialogueController controller;
  final VoidCallback? onDialogueEnd;
  final String? characterName;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? nameTagColor;

  const DialogueBox({
    super.key,
    required this.controller,
    this.onDialogueEnd,
    this.characterName = '곰돌이',
    this.borderColor = const Color(0xFF8B6F47),
    this.backgroundColor = const Color(0xFFFFFEF0),
    this.nameTagColor = const Color(0xFF8B6F47),
  });

  @override
  Widget build(BuildContext context) {


    // ✅ AnimatedBuilder로 감싸야 함!
    return AnimatedBuilder(
      animation: controller,  // ← ChangeNotifier를 animation으로 사용
      builder: (context, child) {

        return GestureDetector(
          onTap: () {

            final isEnd = controller.nextDialogue();
            if (isEnd && onDialogueEnd != null) {

              onDialogueEnd!();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 캐릭터 이름 태그
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: nameTagColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    characterName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 대사 텍스트
                SizedBox(
                  height: 80,
                  child: SingleChildScrollView(
                    child: Text(
                      controller.displayedText + (controller.isTyping ? '▂' : ''),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF5D4E37),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 페이지 정보 및 다음 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.currentIndex + 1}/${controller.dialogues.length}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    if (!controller.isTyping)
                      Row(
                        children: [
                          Text(
                            controller.currentIndex >= controller.dialogues.length - 1
                                ? '닫기'
                                : '다음',
                            style: TextStyle(
                              fontSize: 13,
                              color: borderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: borderColor,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}