import 'package:flutter/material.dart';

class MyCreatorHeaders extends StatelessWidget {
  final String text;
  const MyCreatorHeaders({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 25),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
