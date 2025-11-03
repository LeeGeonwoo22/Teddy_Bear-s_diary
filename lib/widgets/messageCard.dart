import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../common/global.dart';
import '../model/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({super.key, required Message this.message});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    const r = Radius.circular(15);
    return message.msgType == MessageType.bot ?
      Row(
      children: [
        SizedBox( width: 6,),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Image.asset('assets/icons/app_icon.png', width: 24,),
        ),

        Container(
          constraints: BoxConstraints(maxWidth: mq.width * .6),
          margin: EdgeInsets.only(bottom : mq.height * .02, left: mq.width * .02),
          decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.only(topLeft: r, topRight: r,  bottomRight: r)),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: mq.height * .01),
            child: message.msg.isEmpty ?
            AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText(' Please wait....',
                speed: Duration(milliseconds: 100),),
            ], repeatForever: true
            ) : Text(message.msg, textAlign: TextAlign.center,)
          ),
        )
      ],
    ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom : mq.height * .02, left: mq.width * .02),
              decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.only(topLeft: r, topRight: r,  bottomLeft: r)),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: mq.height * .01),
                child: Text(message.msg),
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person)
            ),
          ],
        );
}}
