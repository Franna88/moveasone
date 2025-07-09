import 'package:flutter/material.dart';
import 'dart:async';
import 'package:move_as_one/commonUi/uiColors.dart';

class SetsAndRepsTracker extends StatefulWidget {
  final String exerciseName;
  final int totalSets;
  final int repsPerSet;
  final int exerciseDuration;
  final bool isTimeBased;
  final int restBetweenSets;
  final Function() onComplete;
  final String workoutType; // Added to determine phase colors

  const SetsAndRepsTracker({
    super.key,
    required this.exerciseName,
    required this.totalSets,
    required this.repsPerSet,
    required this.exerciseDuration,
    required this.isTimeBased,
    required this.restBetweenSets,
    required this.onComplete,
    this.workoutType = 'workouts', // Default to main workout
  });

  @override
  State<SetsAndRepsTracker> createState() => _SetsAndRepsTrackerState();
}

class _SetsAndRepsTrackerState extends State<SetsAndRepsTracker>
    with TickerProviderStateMixin {
  int completedSets = 0;
  int currentSet = 1;
  bool isResting = false;
  bool isExerciseComplete = false;
  int remainingRestTime = 0;
  Timer? restTimer;

  late AnimationController _progressAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  final UiColors _colors = UiColors();

  // Get phase color - always use primary blue for consistency
  Color get _phaseColor {
    return _colors.primaryBlue;
  }

  @override
  void initState() {
    super.initState();
    _initializeExerciseData();
    _setupAnimations();
  }

  void _initializeExerciseData() {
    // These are now passed as constructor arguments

    print(
        'DEBUG: Sets and Reps Tracker initialized - ${widget.exerciseName}: ${widget.totalSets} sets x ${widget.repsPerSet} reps, rest: ${widget.restBetweenSets}s');
  }

  void _setupAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.elasticInOut,
    ));

    _pulseAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _pulseAnimationController.dispose();
    restTimer?.cancel();
    super.dispose();
  }

  void _completeSet() {
    if (completedSets < widget.totalSets) {
      setState(() {
        completedSets++;
        currentSet = completedSets + 1;
      });

      _progressAnimationController.animateTo(completedSets / widget.totalSets);

      if (completedSets < widget.totalSets) {
        // Start rest period
        _startRestPeriod();
      } else {
        // Exercise complete
        _completeExercise();
      }
    }
  }

  void _startRestPeriod() {
    setState(() {
      isResting = true;
      remainingRestTime = widget.restBetweenSets;
    });

    // widget.onStatusUpdate('Resting between sets...'); // Removed as per new code

    restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingRestTime--;
      });

      if (remainingRestTime <= 0) {
        timer.cancel();
        setState(() {
          isResting = false;
        });
        // widget.onStatusUpdate('Ready for next set!'); // Removed as per new code
      }
    });
  }

  void _skipRest() {
    restTimer?.cancel();
    setState(() {
      isResting = false;
      remainingRestTime = 0;
    });
    // widget.onStatusUpdate('Ready for next set!'); // Removed as per new code
  }

  void _completeExercise() {
    setState(() {
      isExerciseComplete = true;
    });
    // widget.onStatusUpdate('Exercise completed!'); // Removed as per new code

    // Wait a moment then notify parent
    Future.delayed(const Duration(seconds: 1), () {
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Exercise name and progress
          _buildHeader(),
          const SizedBox(height: 24),

          // Sets progress visualization
          _buildSetsProgress(),
          const SizedBox(height: 24),

          // Current set info or rest screen
          if (isResting)
            _buildRestScreen()
          else if (isExerciseComplete)
            _buildCompletionScreen()
          else
            _buildCurrentSetInfo(),

          const SizedBox(height: 24),

          // Action buttons
          if (!isExerciseComplete) _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          widget.exerciseName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Set $currentSet of ${widget.totalSets}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSetsProgress() {
    return Column(
      children: [
        // Overall progress bar
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _progressAnimation.value == 1.0 ? Colors.green : _phaseColor,
              ),
              minHeight: 8,
            );
          },
        ),
        const SizedBox(height: 16),

        // Individual set indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.totalSets, (index) {
            bool isCompleted = index < completedSets;
            bool isCurrent = index == completedSets && !isExerciseComplete;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedBuilder(
                animation: isCurrent
                    ? _pulseAnimation
                    : const AlwaysStoppedAnimation(1.0),
                builder: (context, child) {
                  return Transform.scale(
                    scale: isCurrent ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? _phaseColor
                                : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent ? _phaseColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCurrentSetInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _phaseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _phaseColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            widget.isTimeBased ? Icons.timer : Icons.repeat,
            size: 48,
            color: _phaseColor,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isTimeBased
                ? 'Hold for ${widget.exerciseDuration} seconds'
                : 'Complete ${widget.repsPerSet} repetitions',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.isTimeBased
                ? 'Focus on maintaining proper form'
                : 'Take your time and maintain good form',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRestScreen() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _colors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _colors.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.spa,
            size: 48,
            color: _colors.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'Rest Time',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$remainingRestTime',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _colors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'seconds remaining',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          const Text(
            'Exercise Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Great work! You completed all ${widget.totalSets} sets.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Continue to next exercise
                    widget.onComplete();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Exit workout early
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Exit Workout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (isResting) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _skipRest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Skip Rest',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _completeSet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              completedSets < widget.totalSets - 1
                  ? 'Complete Set'
                  : 'Finish Exercise',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
