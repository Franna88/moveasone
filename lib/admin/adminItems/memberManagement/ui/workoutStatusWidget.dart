import 'package:flutter/material.dart';

class WorkoutStatusWidget extends StatelessWidget {
  final String action;
  final Color iconColor;
  final Widget progressBarr;
  const WorkoutStatusWidget(
      {super.key, required this.action, required this.iconColor, required this.progressBarr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          action,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF6F6F6F),
            fontSize: 8,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
            height: 1,
            letterSpacing: 0.50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.circle,
            color: iconColor,
            size: 5,
          ),
        ),
        progressBarr
      ],
    );
  }
}
