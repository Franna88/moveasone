import 'package:flutter/material.dart';

class GoalsIconWidget extends StatelessWidget {
  final Color conColor;
  final Color iconColor;
  final IconData iconType;
  final Color borderColor;
  final double iconSize;
  const GoalsIconWidget(
      {super.key,
      required this.conColor,
      required this.iconColor,
      required this.iconType,
      required this.borderColor,
      required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 39,
        width: 39,
        decoration: ShapeDecoration(
          color: borderColor,
          shape: CircleBorder(),
        ),
      ),
      Positioned(
        top: 1.8,
        left: 1.8,
        child: Container(
          height: 35,
          width: 35,
          decoration: ShapeDecoration(
            color: conColor,
            shape: CircleBorder(),
          ),
          child: Icon(
            iconType,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    ]);
  }
}
