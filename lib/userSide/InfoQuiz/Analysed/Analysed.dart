import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/Home/GetStarted.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart';

class Analysed extends StatefulWidget {
  const Analysed({Key? key});

  @override
  State<Analysed> createState() => _AnalysedState();
}

class _AnalysedState extends State<Analysed>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });

    _controller.forward();

    // Navigate to WorkoutCreatorVideo after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetStarted()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/welcomeBack.png'),
            alignment: Alignment(-0.4, 1),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.15),
            CircularProgressBar(progress: _animation.value),
            SizedBox(height: MyUtility(context).height * 0.5),
            SizedBox(
              width: MyUtility(context).width / 1.2,
              child: Text(
                'Your information is',
                style: TextStyle(
                  fontSize: 32.2,
                  fontFamily: 'belight',
                  color: Color(0xFF1E1E1E),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MyUtility(context).width / 1.2,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Signin()),
                ),
                child: Text(
                  'Being Analysed',
                  style: TextStyle(
                      fontSize: 42.2,
                      fontFamily: 'belight',
                      color: Color(0xFF006261)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;
  final double circleRadius;
  final double percentageCircleRadius;

  const CircularProgressBar({
    Key? key,
    required this.progress,
    this.strokeWidth = 5,
    this.color = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.circleRadius = 55,
    this.percentageCircleRadius = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(percentageCircleRadius * 2),
      painter: CircularProgressBarPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor,
        circleRadius: circleRadius,
        percentageCircleRadius: percentageCircleRadius,
      ),
      child: Center(
        child: Text(
          '%${(progress * 100).toStringAsFixed(0)}',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CircularProgressBarPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;
  final double circleRadius;
  final double percentageCircleRadius;

  CircularProgressBarPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
    required this.circleRadius,
    required this.percentageCircleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = circleRadius - strokeWidth / 2;
    final double arcAngle = 2 * math.pi * progress;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = Color(0xFF006261)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, circleRadius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      arcAngle,
      false,
      progressPaint,
    );

    final Paint percentageCirclePaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, percentageCircleRadius, percentageCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
