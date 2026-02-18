import 'package:flutter/material.dart';

import '../../core/common/dialogueController.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';

// 예: 다른 페이지에서 사용
class AnotherPage extends StatefulWidget {
  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  late DialogueController _dialogueController;

  @override
  void initState() {
    super.initState();
    _dialogueController = DialogueController();
    _dialogueController.setDialogues([
      "안녕! 나는 곰돌이야 🧸",
      "오늘 기분이 어때?",
      "같이 이야기해볼까?",
      "여기서는 너가 너의 감정을 바탕으로 다른 무언가를 할 수가 있어"
    ]);


  }

  @override
  void dispose() {
    _dialogueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          const TeddyCharacter(size: 100),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: DialogueBox(
              controller: _dialogueController,
              characterName: '테디',
              onDialogueEnd: () {
                // 대화 종료 후 처리
              },
            ),
          ),
        ],
      ),
    );
  }
}