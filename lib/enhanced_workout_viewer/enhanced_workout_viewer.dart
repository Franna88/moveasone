import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_viewer/screens/workout_detail_viewer.dart';
import 'package:move_as_one/enhanced_workout_viewer/services/workout_service.dart';

/// Main entry point for the Enhanced Workout Viewer module
class EnhancedWorkoutViewer extends StatelessWidget {
  final String workoutId;
  final String userType;

  const EnhancedWorkoutViewer({
    Key? key,
    required this.workoutId,
    this.userType = 'user',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WorkoutDetailViewer(
      workoutId: workoutId,
      userType: userType,
    );
  }

  /// Utility method to get workouts by user's activity level
  static Future<List> getWorkoutsByActivityLevel() async {
    final service = WorkoutViewerService();
    final workouts = await service.getWorkoutsByActivityLevel();

    return workouts
        .map((workout) => {
              'docId': workout.id,
              'displayImage': workout.imageUrl,
              'selectedWeekdays': workout.weekdays.join(', '),
              'bodyArea': workout.bodyArea,
              'difficulty': workout.difficulty,
              'name': workout.name,
              'description': workout.description,
            })
        .toList();
  }

  /// Utility method to get workouts for today
  static Future<List> getTodaysWorkouts() async {
    final service = WorkoutViewerService();
    final workouts = await service.getTodaysWorkouts();

    return workouts
        .map((workout) => {
              'docId': workout.id,
              'displayImage': workout.imageUrl,
              'selectedWeekdays': workout.weekdays.join(', '),
              'bodyArea': workout.bodyArea,
              'difficulty': workout.difficulty,
              'name': workout.name,
              'description': workout.description,
            })
        .toList();
  }
}
