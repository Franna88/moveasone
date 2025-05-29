import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/Signup.dart';

class Analysed extends StatefulWidget {
  final String goal;
  final String gender;
  final String age;
  final String height;
  final String weight;
  final String weightUnit;
  final String activityLevel;

  const Analysed({
    Key? key,
    required this.goal,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.weightUnit,
    required this.activityLevel,
  }) : super(key: key);

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
          MaterialPageRoute(
              builder: (context) => Signup(
                    goal: widget.goal,
                    weight: widget.weight,
                    gender: widget.gender,
                    age: widget.age,
                    height: widget.height,
                    weightUnit: widget.weight,
                    activityLevel: widget.activityLevel,
                  )),
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
            image: AssetImage('images/new_photos/IMG_5617.jpeg'),
            alignment: Alignment(-0.4, 1),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MyUtility(context).height * 0.15),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: CircularProgressBar(progress: _animation.value),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MyUtility(context).width * 0.9,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your information is',
                          style: TextStyle(
                            fontSize: 32.2,
                            fontFamily: 'belight',
                            color: Color(0xFF1E1E1E),
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signin()),
                          ),
                          child: Text(
                            'Being Analysed',
                            style: TextStyle(
                              fontSize: 42.2,
                              fontFamily: 'belight',
                              color: Color(0xFF006261),
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
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
