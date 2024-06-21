import 'package:flutter/material.dart';

class CommentPostButton extends StatelessWidget {
  const CommentPostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xFFAC6AFF)),
      child: Icon(
        Icons.send_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
