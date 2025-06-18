import 'package:flutter/material.dart';
import 'sceenTypes/enhancedExerciseScreen.dart';

class EnhancedWorkoutFlow extends StatefulWidget {
  final Map<String, dynamic> entireExercise;

  const EnhancedWorkoutFlow({
    Key? key,
    required this.entireExercise,
  }) : super(key: key);

  @override
  State<EnhancedWorkoutFlow> createState() => _EnhancedWorkoutFlowState();
}

class _EnhancedWorkoutFlowState extends State<EnhancedWorkoutFlow> {
  List<Map<String, dynamic>> exerciseList = [];
  int currentExerciseIndex = 0;
  bool isLoading = true;
  String currentPhase = '';
  int totalWarmups = 0;
  int totalWorkouts = 0;
  int totalCooldowns = 0;

  @override
  void initState() {
    super.initState();
    _processWorkoutData();
  }

  void _processWorkoutData() {
    print('DEBUG: Enhanced Workout Flow - Processing workout data...');

    // Process warm-ups
    if (widget.entireExercise['warmUps'] != null) {
      _processExerciseGroup(widget.entireExercise['warmUps'], 'warmup');
    }

    // Process main workouts
    if (widget.entireExercise['workouts'] != null) {
      _processExerciseGroup(widget.entireExercise['workouts'], 'workout');
    } else if (widget.entireExercise['exercises'] != null) {
      _processExerciseGroup(widget.entireExercise['exercises'], 'workout');
    }

    // Process cool-downs
    if (widget.entireExercise['coolDowns'] != null) {
      _processExerciseGroup(widget.entireExercise['coolDowns'], 'cooldown');
    } else if (widget.entireExercise['cooldowns'] != null) {
      _processExerciseGroup(widget.entireExercise['cooldowns'], 'cooldown');
    }

    print(
        'DEBUG: Enhanced Workout Flow - Total exercises processed: ${exerciseList.length}');
    _updateCurrentPhase();

    setState(() {
      isLoading = false;
    });
  }

  void _processExerciseGroup(List exerciseGroup, String groupType) {
    for (var exerciseData in exerciseGroup) {
      if (exerciseData == null) continue;

      // Create exercise data structure for the enhanced tracker
      var enhancedExercise = {
        'type': groupType,
        'name': exerciseData['name'] ?? 'Exercise',
        'description': exerciseData['description'] ?? 'Complete the exercise',
        'sets': exerciseData['sets'] ?? 1,
        'reps': exerciseData['reps'] ?? 1,
        'duration': exerciseData['duration'] ?? 30,
        'isTimeBased': exerciseData['isTimeBased'] ?? false,
        'restBetweenSets': exerciseData['restBetweenSets'] ?? 30,
        'mediaType': _determineMediaType(exerciseData),
        'mediaTypeUrl': _getMediaUrl(exerciseData),
        'image': exerciseData['imageUrl'] ?? exerciseData['image'] ?? '',
        'equipment': exerciseData['equipment'] ?? 'No Equipment',
        'difficulty': exerciseData['difficulty'] ?? 'Basic',

        // For compatibility with existing tracker
        'setTotal': (exerciseData['sets'] ?? 1).toString(),
        'repsTotal': (exerciseData['reps'] ?? 1).toString(),
        'timer': exerciseData['restBetweenSets'] ?? 30,
      };

      exerciseList.add(enhancedExercise);

      // Update counters
      switch (groupType) {
        case 'warmup':
          totalWarmups++;
          break;
        case 'workout':
          totalWorkouts++;
          break;
        case 'cooldown':
          totalCooldowns++;
          break;
      }
    }
  }

  String _determineMediaType(Map<String, dynamic> exerciseData) {
    String? videoUrl = exerciseData['videoUrl'];
    String? audioUrl = exerciseData['audioUrl'];

    if (videoUrl != null && videoUrl.isNotEmpty && videoUrl != 'file:///') {
      return 'Video';
    } else if (audioUrl != null &&
        audioUrl.isNotEmpty &&
        audioUrl != 'file:///') {
      return 'Audio';
    }
    return 'Instructions';
  }

  String _getMediaUrl(Map<String, dynamic> exerciseData) {
    String? videoUrl = exerciseData['videoUrl'];
    String? audioUrl = exerciseData['audioUrl'];

    if (videoUrl != null && videoUrl.isNotEmpty && videoUrl != 'file:///') {
      return videoUrl;
    } else if (audioUrl != null &&
        audioUrl.isNotEmpty &&
        audioUrl != 'file:///') {
      return audioUrl;
    }
    return '';
  }

  void _updateCurrentPhase() {
    if (currentExerciseIndex < exerciseList.length) {
      currentPhase = exerciseList[currentExerciseIndex]['type'] ?? '';
    }
  }

  void _nextExercise() {
    if (currentExerciseIndex < exerciseList.length - 1) {
      setState(() {
        currentExerciseIndex++;
        _updateCurrentPhase();
      });
    } else {
      _completeWorkout();
    }
  }

  void _completeWorkout() {
    print('DEBUG: Enhanced Workout Flow - Workout completed!');
    Navigator.pop(context);

    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed your workout.'),
            const SizedBox(height: 16),
            Text('Total exercises completed: ${exerciseList.length}'),
            if (totalWarmups > 0) Text('• Warm-ups: $totalWarmups'),
            if (totalWorkouts > 0) Text('• Main exercises: $totalWorkouts'),
            if (totalCooldowns > 0) Text('• Cool-downs: $totalCooldowns'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  void _onStatusUpdate(String status) {
    print('DEBUG: Enhanced Workout Flow - Status: $status');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (exerciseList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Exercises'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.orange,
              ),
              SizedBox(height: 16),
              Text(
                'No exercises found in this workout',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return EnhancedExerciseScreen(
      exerciseData: exerciseList[currentExerciseIndex],
      onComplete: _nextExercise,
      onStatusUpdate: _onStatusUpdate,
    );
  }
}

// Enhanced Workout Starter Utility
class EnhancedWorkoutStarter {
  static void startEnhancedWorkout(
    BuildContext context,
    Map<String, dynamic> workoutData,
  ) {
    print('DEBUG: Starting Enhanced Workout with Sets & Reps functionality');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedWorkoutFlow(
          entireExercise: workoutData,
        ),
      ),
    );
  }
}
