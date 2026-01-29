import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';
import 'package:teddyBear/features/diary/bloc/diary_event.dart';
import '../../core/common/global.dart';
import '../diary/bloc/diary_bloc.dart';
import '../diary/bloc/diary_state.dart';
import 'widgets/chat_helpers.dart';

class ChatbotFeature extends StatefulWidget {
  const ChatbotFeature({super.key});

  @override
  State<ChatbotFeature> createState() => _ChatbotFeatureState();
}

class _ChatbotFeatureState extends State<ChatbotFeature> {
  final textC = TextEditingController();
  final scrollC = ScrollController();
  final searchC = TextEditingController();
  bool isSearching = false;
  StreamSubscription? _subscription;

  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const LoadMessages());
    // BLoC 상태 변화 감지
    _subscription = context.read<ChatBloc>().stream.listen((state) {
      if (state.messages.isNotEmpty && scrollC.hasClients) {
        // 새 메시지 추가 시 하단으로 스크롤
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollC.animateTo(
            scrollC.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
      // 검색결과 있을 경우 첫 결과로 스크롤 이동
      if (state.searchQuery.isNotEmpty && state.filteredMessages.isNotEmpty) {
        final firstResultIndex = state.messages.indexOf(
            state.filteredMessages.first);
        if (firstResultIndex >= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollC.animateTo(
              firstResultIndex * 80.0, // 메시지 하나당 평균 높이 추정값
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    textC.dispose();
    scrollC.dispose();
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryBloc, DiaryState>(
      listener: (context, state) {
        if (state.isGenerating) {
          print('⏳ 일기 생성 중...');
          // 로딩 다이얼로그 (선택사항)
        }

        if (state.selectedDiary != null) {
          print('✅ 일기 생성 완료!');
          print('제목: ${state.selectedDiary!.title}');
          print('내용: ${state.selectedDiary!.content}');

          // 스낵바로 알림
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('일기가 생성되었습니다!')),
          );
        }

        if (state.errorMessage != null) {
          print('❌ 에러: ${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: isSearching ? TextField(
            controller: searchC,
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search Message',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none
            ),
            onChanged: (value) {
              // ✅ BLoC으로 검색어 전달
              context.read<ChatBloc>().add(SearchMessages(value));
            },
          ) :
          const Text('Chat with Teddy'),
          actions: [
            IconButton(onPressed: (){
              setState(() {
                isSearching = !isSearching ;
                if(!isSearching) {
                  // ✅ BLoC에서 검색 초기화
                  context.read<ChatBloc>().add(const ClearSearch());
                  searchC.clear();
                }
              });
            }, icon: Icon(isSearching ? Icons.close : Icons.search)),
            IconButton(
              onPressed: () {
                print('📝 일기 생성 버튼 클릭!');
                context.read<DiaryBloc>().add(GenerateDiary(date: DateTime.now()));
              },
              icon: Icon(Icons.book),
              tooltip: '일기 생성',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textC,
                  textAlign: TextAlign.center,
                  onTapOutside: (e) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      hintText: 'Ask me anything you want...',
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))
                      )
                  ),
                ),
              ),
              CircleAvatar(
                radius: 24,
                child: IconButton(
                    onPressed: (){
                      final question = textC.text.trim();
                      if(question.isNotEmpty) {
                        context.read<ChatBloc>().add(AskQuestion(question));
                        textC.clear();
                      }
                      // textC.askQuestion();
                    },
                    icon: Icon(
                        Icons.rocket_launch_rounded, size: 28,color: Colors.white
                    )),
              )
            ],
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state)
            {
              // ✅ BLoC에서 필터링된 메시지 사용
              final messages = state.filteredMessages;
      
              final messageWidgets = ChatHelpers.buildMessagesWithDateHeaders(
                messages: messages,
                searchQuery: state.searchQuery,
              );
      
              return ListView(
                physics: BouncingScrollPhysics(),
                controller: scrollC,
                padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
                children:
                messageWidgets,
                  );
            }
        ),
      
      ),
    );
  }
}