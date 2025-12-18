import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';
import 'package:teddyBear/features/chat/widgets/DateHeaders.dart';
import '../../core/common/global.dart';
import '../../core/widgets/messageCard.dart';
import '../../data/model/message.dart';

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
  String searchQuery = '';

  @override
  void dispose() {
    textC.dispose();
    scrollC.dispose();
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ) :
        const Text('Chat with Teddy'),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isSearching = !isSearching ;
              if(!isSearching) {
                searchQuery = '';
                searchC.clear();
              }
            });
          }, icon: Icon(isSearching ? Icons.close : Icons.search))
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
            final messages = searchQuery.isEmpty ? state.messages : state.messages.where((msg)=> msg.msg.toLowerCase().contains(searchQuery)).toList();
            final messageWidgets = _buildMessagesWithDateHeaders(messages);

            return ListView(
              physics: BouncingScrollPhysics(),
              controller: scrollC,
              padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
              children:
              state.messages.map((e)=> MessageCard(message: e)).toList()
                );
          }
      ),

    );

  }
  List<Widget> _buildMessagesWithDateHeaders(List<Message> messages) {
    final widgets = <Widget>[];
    String? lastDate;

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = _formatDate(message.timestamp);

      // 날짜가 바뀌면 DateHeaders 추가
      if (lastDate != messageDate) {
        widgets.add(DateHeaders(dateText: messageDate));  // ✅ 여기서 사용!
        lastDate = messageDate;
      }

      // 메시지 추가 (검색어 하이라이트)
      widgets.add(_buildMessageWithHighlight(message));
    }

    return widgets;
  }

  Widget _buildMessageWithHighlight(Message message) {
    if (searchQuery.isEmpty) {
      return MessageCard(message: message);
    }

    return Container(
      decoration: message.msg.toLowerCase().contains(searchQuery)
          ? BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      )
          : null,
      child: MessageCard(message: message),
    );
  }

  // 날짜 포맷
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDay == today) {
      return '오늘';
    } else if (messageDay == yesterday) {
      return '어제';
    } else if (now.year == dateTime.year) {
      return '${dateTime.month}월 ${dateTime.day}일';
    } else {
      return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
    }
  }
}