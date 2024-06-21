import 'package:flutter/material.dart';

class SenderName extends StatelessWidget {
  final String senderName;
  const SenderName({super.key, required this.senderName});

  @override
  Widget build(BuildContext context) {
    return Text(
      senderName,
      style: TextStyle(
        fontFamily: 'BeVietnam',
        fontSize: 40,
        color: Colors.white,
      ),
    );
  }
}
