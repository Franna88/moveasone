import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'dart:async';
import 'dart:ui';

class EnhancedRestScreen extends StatefulWidget {
  final String imageUrl;
  final Function changePageIndex;
  final int time;
  final String nextExerciseName;

  const EnhancedRestScreen({
    Key? key,
    required this.imageUrl,
    required this.changePageIndex,
    required this.time,
    this.nextExerciseName = "Next Exercise",
  }) : super(key: key);

  @override
  State<EnhancedRestScreen> createState() => _EnhancedRestScreenState();
}

class _EnhancedRestScreenState extends State<EnhancedRestScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.time;

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    // Start countdown timer
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        _timer.cancel();
        widget.changePageIndex();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final timerColor = _remainingSeconds <= 5 ? Colors.red : UiColors().teal;
    final progress = 1 - (_remainingSeconds / widget.time);

    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          // Background image with blur
          widget.imageUrl.isNotEmpty
              ? Positioned.fill(
                  child: Stack(
                    children: [
                      // Main background image
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        width: size.width,
                        height: size.height,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.black,
                            child: Icon(
                              Icons.fitness_center,
                              size: 100,
                              color: Colors.grey.shade800,
                            ),
                          );
                        },
                      ),
                      // Blur overlay effect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          width: size.width,
                          height: size.height,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(color: Colors.black),

          // Animated patterns
          Positioned.fill(
            child: CustomPaint(
              painter: RestPatternPainter(
                progress: progress,
                color: timerColor.withOpacity(0.15),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top info bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    border: Border(
                      bottom: BorderSide(
                        color: UiColors().brown.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: UiColors().brown,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "REST",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "NEXT: ${widget.nextExerciseName}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Central timer with indicators
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated timer
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer spinning ring
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 2,
                            backgroundColor: Colors.white24,
                            color: timerColor,
                          ),
                        ),

                        // Middle progress ring
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: Colors.white10,
                            color: timerColor.withOpacity(0.7),
                          ),
                        ),

                        // Inner timer ring with pulse animation
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _remainingSeconds <= 5
                                  ? _pulseAnimation.value
                                  : 1.0,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.6),
                                  border: Border.all(
                                    color: timerColor,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _formatTime(_remainingSeconds),
                                    style: TextStyle(
                                      color: _remainingSeconds <= 5
                                          ? Colors.red
                                          : Colors.white,
                                      fontSize: 46,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Message for user
                    Text(
                      "Breathe and prepare for",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.nextExerciseName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Bottom action area
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => widget.changePageIndex(),
                        icon: const Icon(Icons.skip_next_rounded),
                        label: const Text("SKIP REST"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UiColors().teal,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 8,
                          shadowColor: UiColors().teal.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for creating animated background patterns
class RestPatternPainter extends CustomPainter {
  final double progress;
  final Color color;

  RestPatternPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw diagonal lines
    for (double i = 0; i < size.width * 2; i += 40) {
      final offset = i * progress * 0.5;
      canvas.drawLine(
        Offset(-size.width + i + offset, 0),
        Offset(i - offset, size.height),
        paint,
      );
    }

    // Draw small circles at intersections
    for (double x = 0; x < size.width; x += 40) {
      for (double y = 0; y < size.height; y += 40) {
        final offset = Offset(x, y);
        canvas.drawCircle(offset, 1.5, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(RestPatternPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
