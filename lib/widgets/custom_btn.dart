import 'package:flutter/material.dart';
import '../common/global.dart';


class CustomBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const CustomBtn({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            shape: StadiumBorder(), elevation: 0, minimumSize: Size(mq.width * .4, 50)),
        onPressed: (){
          onTap();
        }, child: Text(text));
  }
}
