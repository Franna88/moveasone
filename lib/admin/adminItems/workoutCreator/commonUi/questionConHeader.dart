import 'package:flutter/material.dart';

class QuestionConHeader extends StatelessWidget {
  final String header;
  const QuestionConHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 4,
          width: 25,
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 20),
          child: Text(
            header,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              shadows: [
                Shadow(
                  offset: Offset(3, 3),
                  blurRadius: 5.0,
                  color: const Color.fromARGB(132, 158, 158, 158),
                ),
              ],
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
