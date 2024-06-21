/*import 'dart:math';
import 'package:flutter/material.dart';


class StatusBarActivity extends StatelessWidget {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  StatusBarActivity({
    required this.percentage,
    this.strokeWidth = 6.5,
    this.backgroundColor = const Color.fromARGB(255, 204, 203, 203),
    this.progressColor = const Color.fromARGB(255, 1, 102, 92),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        child: CustomPaint(
          painter: _CircularProgressBarPainter(
            percentage: percentage,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
          ),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5,),
                Text(
                  'Status',
                  style: TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 10,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    height: 0.16,
                    letterSpacing: 0.40,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _CircularProgressBarPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final Offset center = Offset(halfWidth, halfHeight);
    final double radius = min(halfWidth, halfHeight) - (strokeWidth / 2);

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(center, radius, backgroundPaint);

    final double sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}*/




import 'dart:math';
import 'package:flutter/material.dart';

class StatusBarActivity extends StatelessWidget {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;

  StatusBarActivity({
    required this.percentage,
    this.strokeWidth = 6.5,
    this.backgroundColor = const Color.fromARGB(255, 196, 219, 245),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        child: CustomPaint(
          painter: _CircularProgressBarPainter(
            percentage: percentage,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor,
            progressColor: _getColor(percentage),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Status',
                  style: TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 10,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    height: 0.16,
                    letterSpacing: 0.40,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                     fontFamily: 'Lato',
                    fontSize: 13,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(double percentage) {
    if (percentage > 50) {
      return Colors.green;
    } else if (percentage >= 35 && percentage <= 49) {
      return Color.fromARGB(255, 197, 120, 68);
    } else {
      return Colors.red;
    }
  }
}

class _CircularProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _CircularProgressBarPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final Offset center = Offset(halfWidth, halfHeight);
    final double radius = min(halfWidth, halfHeight) - (strokeWidth / 2);

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // Changed to round

    canvas.drawCircle(center, radius, backgroundPaint);

    final double sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
