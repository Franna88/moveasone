import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:move_as_one/enhanced_workout_viewer/models/workout_model.dart';

class WorkoutViewerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get workout by ID
  Future<WorkoutModel?> getWorkoutById(String workoutId) async {
    try {
      // First try to get from the new enhanced workouts collection
      final enhancedDocSnapshot =
          await _firestore.collection('workouts').doc(workoutId).get();

      // If found in enhanced collection, use that
      if (enhancedDocSnapshot.exists) {
        final data = enhancedDocSnapshot.data() as Map<String, dynamic>;
        return _sanitizeWorkoutModel(
            WorkoutModel.fromJson({...data, 'id': workoutId}));
      }

      // Otherwise try the legacy collection
      final legacyDocSnapshot =
          await _firestore.collection('createWorkout').doc(workoutId).get();

      if (!legacyDocSnapshot.exists) {
        return null;
      }

      final data = legacyDocSnapshot.data() as Map<String, dynamic>;
      return _sanitizeWorkoutModel(
          WorkoutModel.fromJson({...data, 'id': workoutId}));
    } catch (e) {
      debugPrint('Error getting workout by ID: $e');
      rethrow;
    }
  }

  // Helper method to sanitize workout data (validate URLs, etc.)
  WorkoutModel _sanitizeWorkoutModel(WorkoutModel workout) {
    // Check if the image URL is valid
    String imageUrl = '';
    if (workout.imageUrl.isNotEmpty &&
        (workout.imageUrl.startsWith('http://') ||
            workout.imageUrl.startsWith('https://'))) {
      imageUrl = workout.imageUrl;
    }

    // Sanitize exercise data
    List<ExerciseModel> sanitizeExercises(List<ExerciseModel> exercises) {
      return exercises.map((exercise) {
        String sanitizedImageUrl = '';
        if (exercise.imageUrl.isNotEmpty &&
            (exercise.imageUrl.startsWith('http://') ||
                exercise.imageUrl.startsWith('https://'))) {
          sanitizedImageUrl = exercise.imageUrl;
        }

        String sanitizedVideoUrl = '';
        if (exercise.videoUrl.isNotEmpty &&
            (exercise.videoUrl.startsWith('http://') ||
                exercise.videoUrl.startsWith('https://'))) {
          sanitizedVideoUrl = exercise.videoUrl;
        }

        String sanitizedAudioUrl = '';
        if (exercise.audioUrl.isNotEmpty &&
            (exercise.audioUrl.startsWith('http://') ||
                exercise.audioUrl.startsWith('https://'))) {
          sanitizedAudioUrl = exercise.audioUrl;
        }

        return ExerciseModel(
          id: exercise.id,
          name: exercise.name,
          description: exercise.description,
          imageUrl: sanitizedImageUrl,
          videoUrl: sanitizedVideoUrl,
          audioUrl: sanitizedAudioUrl,
          equipment: exercise.equipment,
          difficulty: exercise.difficulty,
          sets: exercise.sets,
          reps: exercise.reps,
          restBetweenSets: exercise.restBetweenSets,
          duration: exercise.duration,
          isTimeBased: exercise.isTimeBased,
          selectedMinutes: exercise.selectedMinutes,
          selectedSeconds: exercise.selectedSeconds,
          repetition: exercise.repetition,
        );
      }).toList();
    }

    return WorkoutModel(
      id: workout.id,
      name: workout.name,
      description: workout.description,
      imageUrl: imageUrl,
      bodyArea: workout.bodyArea,
      difficulty: workout.difficulty,
      equipment: workout.equipment,
      categories: workout.categories,
      weekdays: workout.weekdays,
      duration: workout.duration,
      warmups: sanitizeExercises(workout.warmups),
      exercises: sanitizeExercises(workout.exercises),
      cooldowns: sanitizeExercises(workout.cooldowns),
    );
  }

  // Get all workouts from both collections
  Future<List<WorkoutModel>> getAllWorkouts() async {
    try {
      List<WorkoutModel> allWorkouts = [];

      // Get workouts from enhanced collection
      final enhancedSnapshot = await _firestore.collection('workouts').get();
      allWorkouts.addAll(enhancedSnapshot.docs
          .map((doc) => WorkoutModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());

      // Get workouts from legacy collection
      final legacySnapshot = await _firestore.collection('createWorkout').get();
      allWorkouts.addAll(legacySnapshot.docs
          .map((doc) => WorkoutModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());

      return allWorkouts;
    } catch (e) {
      debugPrint('Error getting all workouts: $e');
      return [];
    }
  }

  // Get workouts by user's activity level
  Future<List<WorkoutModel>> getWorkoutsByActivityLevel() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      // Get user's activity level
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return [];
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final activityLevel = userData['activityLevel'] as String? ?? '';

      if (activityLevel.isEmpty) {
        return [];
      }

      List<WorkoutModel> matchingWorkouts = [];

      // Check enhanced collection
      final enhancedQuerySnapshot = await _firestore
          .collection('workouts')
          .where('difficulty', isEqualTo: activityLevel)
          .get();

      matchingWorkouts.addAll(enhancedQuerySnapshot.docs
          .map((doc) => WorkoutModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());

      // Check legacy collection
      final legacyQuerySnapshot = await _firestore
          .collection('createWorkout')
          .where('difficulty', isEqualTo: activityLevel)
          .get();

      matchingWorkouts.addAll(legacyQuerySnapshot.docs
          .map((doc) => WorkoutModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());

      return matchingWorkouts;
    } catch (e) {
      debugPrint('Error getting workouts by activity level: $e');
      return [];
    }
  }

  // Get workouts for specific weekday (today or specific day)
  Future<List<WorkoutModel>> getWorkoutsByWeekday(String weekday) async {
    try {
      List<WorkoutModel> allWorkouts = await getAllWorkouts();

      // Filter workouts for the specific weekday
      return allWorkouts
          .where((workout) => workout.weekdays.contains(weekday))
          .toList();
    } catch (e) {
      debugPrint('Error getting workouts by weekday: $e');
      return [];
    }
  }

  // Get today's workouts based on user's activity level and current weekday
  Future<List<WorkoutModel>> getTodaysWorkouts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      // Get current weekday
      final now = DateTime.now();
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      final todayWeekday = weekdays[now.weekday - 1]; // weekday is 1-7 in Dart

      // Get user's activity level
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return [];
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final activityLevel = userData['activityLevel'] as String? ?? '';

      if (activityLevel.isEmpty) {
        return [];
      }

      List<WorkoutModel> matchingWorkouts = [];

      // Check enhanced collection
      final enhancedQuerySnapshot = await _firestore
          .collection('workouts')
          .where('difficulty', isEqualTo: activityLevel)
          .get();

      final enhancedWorkouts = enhancedQuerySnapshot.docs
          .map((doc) => WorkoutModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      matchingWorkouts.addAll(enhancedWorkouts
          .where((workout) => workout.weekdays.contains(todayWeekday))
          .toList());

      // Check legacy collection
      final legacyQuerySnapshot = await _firestore
          .collection('createWorkout')
          .where('difficulty', isEqualTo: activityLevel)
          .get();

      final legacyWorkouts = legacyQuerySnapshot.docs
          .map((doc) => WorkoutModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      matchingWorkouts.addAll(legacyWorkouts
          .where((workout) => workout.weekdays.contains(todayWeekday))
          .toList());

      return matchingWorkouts;
    } catch (e) {
      debugPrint('Error getting today\'s workouts: $e');
      return [];
    }
  }
}
