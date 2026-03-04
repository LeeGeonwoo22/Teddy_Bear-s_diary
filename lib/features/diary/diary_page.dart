import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/core/common/dialogueController.dart';
import 'package:teddyBear/features/diary/widgets/diaryCalendar.dart';
import 'package:teddyBear/features/diary/widgets/emojiBottomSheet.dart';
import '../../core/widgets/dialogBox.dart';
import '../../core/widgets/teddyCharacter.dart';
import 'bloc/diary_bloc.dart';
import 'bloc/diary_event.dart';
import 'bloc/diary_state.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late DialogueController _dialogueController;

  @override
  void initState() {
    super.initState();


    // 앱 시작 시 전체 일기 불러오기
    context.read<DiaryBloc>().add(const LoadDiaries());

    // Animation 초기화
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // 초기 대사
    _dialogueController = DialogueController();
    _dialogueController.setDialogues(["어느 일기를 같이 읽어볼까? 🧸"]);
  }

  @override
  void dispose() {
    _dialogueController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleDialogueEnd() {

    final state = context.read<DiaryBloc>().state;
    final diary = state.diaries[state.selectedDate];



    if (state.selectedDate == null) return;
    // ✅ 일기 유무 상관없이 바로 띄움
    _showEmotionAskDialog(state.selectedDate!);
  }

  void _showEmotionAskDialog(DateTime date) {
    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

    final state = context.read<DiaryBloc>().state;
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final currentEmotion = state.diaries[normalizedDate]?.emotion;
    print('🔍 현재 날짜: $normalizedDate');
    print('🔍 현재 이모지: $currentEmotion');
    print('🔍 오늘 여부: $isToday');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🧸', style: TextStyle(fontSize: 40)),
            SizedBox(height: 12),
            Text('오늘 일기 어땠어?\n이모지 남겨볼래?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 아니오 → 초기 대사로
              _dialogueController.setDialogues(["어느 일기를 같이 읽어볼까? 🧸"]);
            },
            child: Text('아니야'),
          ),
          if (isToday)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 예 → 이모지 선택
              _showEmotionPicker(date);
            },
            child: Text('응!'),
          ),
        ],
      ),
    );
  }

  // 날짜 클릭 핸들러
  void _handleDaySelected(DateTime selectedDay) {
    context.read<DiaryBloc>().add(SelectDiary(selectedDay));
  }

  void _showEmotionPicker(DateTime date) {
    final emotions = [
      {'emoji': '😊', 'label': '응, 괜찮아'},
      {'emoji': '😢', 'label': '아니야.. 슬퍼'},
      {'emoji': '😤', 'label': '음.. 답답해'},
      {'emoji': '🤔', 'label': '잘 모르겠어'},
      {'emoji': '😴', 'label': '그냥 그래'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('오늘 기분은?', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: emotions.map((e) =>
              ListTile(
                leading: Text(e['emoji']!, style: TextStyle(fontSize: 24)),
                title: Text(e['label']!),
                onTap: () {
                  print('✅ 이모지 선택: ${e['emoji']}');
                  context.read<DiaryBloc>().add(
                    UpdateEmotion(
                      date: date,
                      emotion: e['emoji']!,
                    ),
                  );
                  Navigator.pop(context);
                  // 선택 후 초기 대사로
                  _dialogueController.setDialogues(["어느 일기를 같이 읽어볼까? 🧸"]);
                },
              ),
          ).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryBloc, DiaryState>(
      listener: (context, state) {
        // 날짜 선택 시 대사 업데이트
        if (state.selectedDate != null) {
         // print("📆 선택된 날짜: ${state.selectedDate}");
          final diary = state.diaries[state.selectedDate];
          List<String> newDialogues;
          if (diary != null) {
           // print("📖 일기 발견: ${diary.title}");
            newDialogues = [
              '${state.selectedDate!.month}월 ${state.selectedDate!.day}일 일기를 읽어줄게',
              diary.title,
              ...diary.content.split('\n\n'),
              '오늘 하루 수고했어 💛',
            ];
          } else {
            //print("📭 일기 없음");
            newDialogues = ['이 날은 기록된 이야기가 없네.. 🧸'];
          }
          _dialogueController.setDialogues(newDialogues);
          _controller.forward(from: 0.0);
        } else {
          // print("⚠️ selectedDate가 null");
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Teddy Bear's Diary",
            style: TextStyle(
              color: Color(0xFF8B6F47),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF8B6F47)),
              onPressed: () {

              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              // 달력 영역
              Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: DiaryCalendar(onDaySelected: _handleDaySelected),
                ),
              ),

              // 대화창 영역
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Spacer(flex: 1),
                        SlideTransition(
                          position: _slideAnimation,
                          child: TeddyCharacter(),
                        ),
                        const Spacer(),
                        Builder(
                            builder: (context) {
                              return DialogueBox(
                                controller: _dialogueController,
                                onDialogueEnd: _handleDialogueEnd,
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}