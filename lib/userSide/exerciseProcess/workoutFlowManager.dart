import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/exerciseProcess/exerciseProcess.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/workoutStartScreen.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class WorkoutFlowManager extends StatefulWidget {
  final Map entireExercise;

  const WorkoutFlowManager({
    super.key,
    required this.entireExercise,
  });

  @override
  State<WorkoutFlowManager> createState() => _WorkoutFlowManagerState();
}

class _WorkoutFlowManagerState extends State<WorkoutFlowManager> {
  bool _hasStarted = false;
  bool _isLoading = false;

  void _startWorkout() {
    print('DEBUG: _startWorkout called'); // Debug print
    setState(() {
      _isLoading = true;
    });

    // Add a small delay to show the loading state
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _hasStarted = true;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UiColors colors = UiColors();

    print(
        'DEBUG: WorkoutFlowManager build - hasStarted: $_hasStarted, isLoading: $_isLoading'); // Debug print

    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.primaryBlue.withOpacity(0.1),
                colors.primaryBlue.withOpacity(0.05),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primaryBlue),
                ),
                const SizedBox(height: 16),
                Text(
                  'Starting your workout...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_hasStarted) {
      return WorkoutStartScreen(
        entireExercise: widget.entireExercise,
        onStartWorkout: _startWorkout,
      );
    }

    try {
      return ExerciseProcess(
        entireExercise: widget.entireExercise,
      );
    } catch (e) {
      print('DEBUG: Error creating ExerciseProcess: $e'); // Debug print
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error starting workout',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Please try again or check your workout data.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasStarted = false;
                  });
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
  }
}

// Enhanced workout starter that provides a better entry point
class EnhancedWorkoutStarter {
  /// Starts a workout flow with the new enhanced experience
  static void startWorkout(
    BuildContext context,
    Map<String, dynamic> entireExercise,
  ) {
    print(
        'DEBUG: EnhancedWorkoutStarter.startWorkout called with data: ${entireExercise.keys}'); // Debug print

    // Validate that we have at least one exercise
    bool hasWarmups = entireExercise['warmUps'] != null &&
        entireExercise['warmUps'] is List &&
        (entireExercise['warmUps'] as List).isNotEmpty;

    bool hasWorkouts = (entireExercise['workouts'] != null &&
            entireExercise['workouts'] is List &&
            (entireExercise['workouts'] as List).isNotEmpty) ||
        (entireExercise['exercises'] != null &&
            entireExercise['exercises'] is List &&
            (entireExercise['exercises'] as List).isNotEmpty);

    bool hasCooldowns = (entireExercise['coolDowns'] != null &&
            entireExercise['coolDowns'] is List &&
            (entireExercise['coolDowns'] as List).isNotEmpty) ||
        (entireExercise['cooldowns'] != null &&
            entireExercise['cooldowns'] is List &&
            (entireExercise['cooldowns'] as List).isNotEmpty);

    print(
        'DEBUG: Exercise validation - warmups: $hasWarmups, workouts: $hasWorkouts, cooldowns: $hasCooldowns'); // Debug print

    // Check if workout has any exercises
    if (!hasWarmups && !hasWorkouts && !hasCooldowns) {
      print('DEBUG: No exercises found, showing dialog'); // Debug print
      _showNoExercisesDialog(context);
      return;
    }

    print('DEBUG: Navigating to WorkoutFlowManager'); // Debug print

    try {
      // Navigate to the enhanced workout flow
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutFlowManager(
            entireExercise: entireExercise,
          ),
        ),
      );
    } catch (e) {
      print('DEBUG: Error navigating to WorkoutFlowManager: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting workout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Shows a dialog when no exercises are found
  static void _showNoExercisesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('No Exercises Found'),
          ],
        ),
        content: const Text(
          'This workout doesn\'t contain any exercises to perform. Please check with the workout creator.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Starts a workout directly (bypasses the start screen)
  static void startWorkoutDirectly(
    BuildContext context,
    Map<String, dynamic> entireExercise,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseProcess(
          entireExercise: entireExercise,
        ),
      ),
    );
  }

  /// Creates a preview of the workout structure
  static Map<String, dynamic> getWorkoutPreview(
      Map<String, dynamic> entireExercise) {
    int warmupCount = 0;
    int workoutCount = 0;
    int cooldownCount = 0;
    int estimatedDuration = 0;

    // Count warm-ups
    if (entireExercise['warmUps'] != null &&
        entireExercise['warmUps'] is List) {
      warmupCount = (entireExercise['warmUps'] as List).length;
      estimatedDuration += warmupCount * 2; // 2 minutes per warm-up
    }

    // Count main workouts
    if (entireExercise['workouts'] != null &&
        entireExercise['workouts'] is List) {
      workoutCount = (entireExercise['workouts'] as List).length;
      estimatedDuration += workoutCount * 3; // 3 minutes per exercise
    } else if (entireExercise['exercises'] != null &&
        entireExercise['exercises'] is List) {
      workoutCount = (entireExercise['exercises'] as List).length;
      estimatedDuration += workoutCount * 3;
    }

    // Count cool-downs
    if (entireExercise['coolDowns'] != null &&
        entireExercise['coolDowns'] is List) {
      cooldownCount = (entireExercise['coolDowns'] as List).length;
      estimatedDuration += cooldownCount * 2; // 2 minutes per cool-down
    } else if (entireExercise['cooldowns'] != null &&
        entireExercise['cooldowns'] is List) {
      cooldownCount = (entireExercise['cooldowns'] as List).length;
      estimatedDuration += cooldownCount * 2;
    }

    // Use provided duration if available
    if (entireExercise['estimatedDuration'] != null) {
      estimatedDuration = entireExercise['estimatedDuration'];
    }

    return {
      'warmupCount': warmupCount,
      'workoutCount': workoutCount,
      'cooldownCount': cooldownCount,
      'totalExercises': warmupCount + workoutCount + cooldownCount,
      'estimatedDuration': estimatedDuration,
      'hasWarmups': warmupCount > 0,
      'hasWorkouts': workoutCount > 0,
      'hasCooldowns': cooldownCount > 0,
    };
  }

  /// Validates workout structure
  static bool validateWorkout(Map<String, dynamic> entireExercise) {
    Map<String, dynamic> preview = getWorkoutPreview(entireExercise);
    return preview['totalExercises'] > 0;
  }
}
