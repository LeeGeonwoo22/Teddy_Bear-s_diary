import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api/apis.dart';
import '../data/model/message.dart';


class ChatController extends GetxController {
  final scrollC = ScrollController();
  final textC = TextEditingController();
   final list = <Message>[
     Message(msg: 'Hello, How can i help you?', msgType: MessageType.bot)
   ].obs;

   void askQuestion() async {
     if(textC.text.trim().isNotEmpty) {
       // user
       list.add(Message(msg: textC.text, msgType: MessageType.user));
       list.add(Message(msg: '', msgType: MessageType.bot));
       // list.add(Message(msg: 'Please wait', msgType: MessageType.bot));
       _scrollDown();

       final res = await APIs.getAnswer(textC.text);
       // ai bot
       list.removeLast();
       list.add(Message(msg: res, msgType: MessageType.bot));
       // list.add(Message(msg: 'I received your message', msgType: MessageType.bot));
       _scrollDown();
         textC.text = '';
     }
   }

   void _scrollDown(){
     scrollC.animateTo(scrollC.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease);
   }
}