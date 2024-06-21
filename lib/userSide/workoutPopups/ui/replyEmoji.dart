import 'package:flutter/material.dart';

class ReplyEmoji extends StatelessWidget {
  final String emojiImage;
  final String replyText;
  const ReplyEmoji(
      {super.key, required this.replyText, required this.emojiImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 10,
          color: const Color.fromARGB(0, 255, 255, 255),
          shape: CircleBorder(),
          child: Container(
            height: 60,
            width: 60,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: const Color.fromARGB(113, 255, 255, 255),
            ),
            child: Center(
                child: Image.asset(
              emojiImage,
              height: 30,
            )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          replyText,
          style: TextStyle(
            fontFamily: 'BeVietnam',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
