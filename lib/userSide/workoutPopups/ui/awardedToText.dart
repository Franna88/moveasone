import 'package:flutter/material.dart';

class AwardedToText extends StatelessWidget {
  final String awardedTo;
  const AwardedToText({super.key, required this.awardedTo});

  @override
  Widget build(BuildContext context) {
    return Text(
      awardedTo,
      style: TextStyle(
        fontFamily: 'BeVietnam',
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
