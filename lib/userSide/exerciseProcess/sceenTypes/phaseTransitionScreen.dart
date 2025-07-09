import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class PhaseTransitionScreen extends StatefulWidget {
  final String fromPhase;
  final String toPhase;
  final Function() onContinue;
  final String nextExerciseName;
  final int totalPhasesRemaining;

  const PhaseTransitionScreen({
    super.key,
    required this.fromPhase,
    required this.toPhase,
    required this.onContinue,
    required this.nextExerciseName,
    required this.totalPhasesRemaining,
  });

  @override
  State<PhaseTransitionScreen> createState() => _PhaseTransitionScreenState();
}

class _PhaseTransitionScreenState extends State<PhaseTransitionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Use app's color scheme
  final UiColors _colors = UiColors();

  String get _phaseTitle {
    switch (widget.toPhase.toLowerCase()) {
      case 'warmup':
      case 'warm-up':
        return 'WARM UP';
      case 'workouts':
        return 'MAIN WORKOUT';
      case 'cooldowns':
      case 'cool-down':
        return 'COOL DOWN';
      default:
        return widget.toPhase.toUpperCase();
    }
  }

  String get _phaseDescription {
    switch (widget.toPhase.toLowerCase()) {
      case 'warmup':
      case 'warm-up':
        return 'Prepare your body with gentle movements';
      case 'workouts':
        return 'Time to push yourself and get stronger';
      case 'cooldowns':
      case 'cool-down':
        return 'Relax and let your body recover';
      default:
        return 'Continue with your workout';
    }
  }

  IconData get _phaseIcon {
    switch (widget.toPhase.toLowerCase()) {
      case 'warmup':
      case 'warm-up':
        return Icons.local_fire_department;
      case 'workouts':
        return Icons.fitness_center;
      case 'cooldowns':
      case 'cool-down':
        return Icons.spa;
      default:
        return Icons.directions_run;
    }
  }

  Color get _phaseColor {
    // Always return primary blue for consistency
    return _colors.primaryBlue;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _phaseColor.withOpacity(0.1),
              _phaseColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phase Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _phaseColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _phaseColor,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          _phaseIcon,
                          size: 60,
                          color: _phaseColor,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Phase Title
                      Text(
                        _phaseTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _phaseColor,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Phase Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _phaseDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Next Exercise Preview
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Next Exercise:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.nextExerciseName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Progress Indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text(
                              '${widget.totalPhasesRemaining} exercises remaining in this phase',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Continue Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: widget.onContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _phaseColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'START ${_phaseTitle}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
