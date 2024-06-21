import 'package:flutter/material.dart';

class GoalsProgressBar extends StatelessWidget {
  final Color barColor;
  final double barValue;
  const GoalsProgressBar({super.key, required this.barColor, required this.barValue});

  @override
  Widget build(BuildContext context) {
    double progress = barValue; 
    var widthDevice = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        height: 8,
        width: widthDevice * 0.65, 
        child: LinearProgressIndicator(
          borderRadius: BorderRadius.circular(5),
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(barColor),
        ),
      ),
    );
  }
}
