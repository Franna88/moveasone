import 'package:flutter/material.dart';

class MyLinearProgressBar extends StatelessWidget {
  final Color barColor;
  final double barValue;
  final Color backgroundColor;
  final double width;
  const MyLinearProgressBar({super.key, required this.barColor, required this.barValue, required this.backgroundColor, required this.width});

  @override
  Widget build(BuildContext context) {
    double progress = barValue; 
    var widthDevice = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        height: 8,
        width: widthDevice * width, 
        child: LinearProgressIndicator(
          borderRadius: BorderRadius.circular(5),
          value: progress,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(barColor),
        ),
      ),
    );
  }
}