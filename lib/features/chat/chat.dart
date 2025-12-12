import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_bloc.dart';
import 'package:teddyBear/features/chat/bloc/chat_event.dart';
import 'package:teddyBear/features/chat/bloc/chat_state.dart';
import '../../core/common/global.dart';
import '../../core/widgets/messageCard.dart';



class ChatbotFeature extends StatefulWidget {
  const ChatbotFeature({super.key});

  @override
  State<ChatbotFeature> createState() => _ChatbotFeatureState();
}

class _ChatbotFeatureState extends State<ChatbotFeature> {
  final textC = TextEditingController();
  final scrollC = ScrollController();
  // final _c = ChatController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Teddy'),
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
      body:

      BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state)
          {
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
}