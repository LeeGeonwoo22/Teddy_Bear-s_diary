import 'dart:async';
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
    _dialogueController.setDialogues(["어느 일기를 같이 읽어볼까? 🧸"]);
    final state = context.read<DiaryBloc>().state;

    if (state.selectedDate != null) {
      _showFeedbackBottomSheet(state.selectedDate!);
    }
  }

  // 날짜 클릭 핸들러
  void _handleDaySelected(DateTime selectedDay) {
    context.read<DiaryBloc>().add(SelectDiary(selectedDay));
  }

  void _showFeedbackBottomSheet(DateTime date) {
    showModalBottomSheet(context: context, builder: (context) => EmojiBottomsheet(
      // date : date,

    ));
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
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: DiaryCalendar(onDaySelected: _handleDaySelected),
                ),
              ),

              // 대화창 영역
              Flexible(
                flex: 2,
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
                        const SizedBox(height: 20),
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