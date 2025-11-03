import 'package:flutter/material.dart';

import '../../common/global.dart';
import '../../controller/chat_controller.dart';
import 'package:get/get.dart';

import '../../widgets/messageCard.dart';

class ChatbotFeature extends StatefulWidget {
  const ChatbotFeature({super.key});

  @override
  State<ChatbotFeature> createState() => _ChatbotFeatureState();
}

class _ChatbotFeatureState extends State<ChatbotFeature> {
  final _c = ChatController();
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
                controller: _c.textC,
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
                    _c.askQuestion();
                  },
                  icon: Icon(
                      Icons.rocket_launch_rounded, size: 28,color: Colors.white
                  )),
            )
          ],
        ),
      ),
      body:
      Obx(
            ()=> ListView(
          physics: BouncingScrollPhysics(),
          controller: _c.scrollC,
          padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
          children:
          _c.list.map((e)=> MessageCard(message: e)).toList()
          ,
        ),
      ),

    );
  }
}