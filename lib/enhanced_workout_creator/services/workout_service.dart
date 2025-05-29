import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_model.dart';
import 'package:uuid/uuid.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'createWorkout';

  // Create a new workout
  Future<String> createWorkout(Workout workout) async {
    try {
      // Generate document ID if not provided
      String docId = workout.id;

      // Convert the workout model into the format used by the old workout creator
      Map<String, dynamic> workoutData = {
        'name': workout.name,
        'description': workout.description,
        'imageUrl': workout.imageUrl,
        'categories': workout.categories,
        'difficulty': workout.difficulty,
        'bodyAreas': workout.bodyAreas,
        'equipment': workout.equipment,
        'weekdays': workout.weekdays,
        'estimatedDuration': workout.estimatedDuration,
        'createdAt': Timestamp.fromDate(workout.createdAt),
        'updatedAt': Timestamp.fromDate(workout.updatedAt),
        // Convert exercises to arrays in the document
        'warmUps': _convertExercisesToOldFormat(workout.warmups),
        'workouts': _convertExercisesToOldFormat(workout.exercises),
        'coolDowns': _convertExercisesToOldFormat(workout.cooldowns),
      };

      await _firestore.collection(collectionName).doc(docId).set(workoutData);
      return docId;
    } catch (e) {
      debugPrint('Error creating workout: $e');
      rethrow;
    }
  }

  // Helper method to convert exercise objects to the old format
  List<Map<String, dynamic>> _convertExercisesToOldFormat(
      List<WorkoutExercise> exercises) {
    return exercises
        .map((exercise) => {
              'itemId': exercise.id,
              'name': exercise.name,
              'description': exercise.description,
              'image': exercise.imageUrl,
              'videoUrl': exercise.videoUrl,
              'audioUrl': exercise.audioUrl,
              'equipment': exercise.equipment,
              'difficulty': exercise.difficulty,
              'repetition': exercise.reps
                  .toString(), // Convert to string to match old format
              'selectedMinutes': exercise.duration ~/
                  60, // Convert duration seconds to minutes
              'selectedSeconds':
                  exercise.duration % 60, // Get remainder seconds
              'time': 1.0, // Default value from old creator
              'topic': 'Strength', // Default topic to maintain compatibility
            })
        .toList();
  }

  // Update an existing workout
  Future<void> updateWorkout(Workout workout) async {
    try {
      Map<String, dynamic> workoutData = {
        'name': workout.name,
        'description': workout.description,
        'imageUrl': workout.imageUrl,
        'categories': workout.categories,
        'difficulty': workout.difficulty,
        'bodyAreas': workout.bodyAreas,
        'equipment': workout.equipment,
        'weekdays': workout.weekdays,
        'estimatedDuration': workout.estimatedDuration,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        // Convert exercises to arrays in the document
        'warmUps': _convertExercisesToOldFormat(workout.warmups),
        'workouts': _convertExercisesToOldFormat(workout.exercises),
        'coolDowns': _convertExercisesToOldFormat(workout.cooldowns),
      };

      await _firestore
          .collection(collectionName)
          .doc(workout.id)
          .update(workoutData);
    } catch (e) {
      debugPrint('Error updating workout: $e');
      rethrow;
    }
  }

  // Get a workout by ID
  Future<Workout?> getWorkout(String id) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        return _convertOldFormatToWorkout(doc.data()!, id);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting workout: $e');
      rethrow;
    }
  }

  // Helper method to convert old format to Workout model
  Workout _convertOldFormatToWorkout(Map<String, dynamic> data, String id) {
    // Extract exercises from the old format
    List<WorkoutExercise> warmups =
        _convertOldFormatToExercises(data['warmUps'] ?? []);
    List<WorkoutExercise> exercises =
        _convertOldFormatToExercises(data['workouts'] ?? []);
    List<WorkoutExercise> cooldowns =
        _convertOldFormatToExercises(data['coolDowns'] ?? []);

    // Create Workout model
    return Workout(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      categories: List<String>.from(data['categories'] ?? []),
      difficulty: data['difficulty'] ?? '',
      bodyAreas: List<String>.from(data['bodyAreas'] ?? []),
      equipment: List<String>.from(data['equipment'] ?? []),
      weekdays: List<String>.from(data['weekdays'] ?? []),
      estimatedDuration: data['estimatedDuration'] ?? 0,
      warmups: warmups,
      exercises: exercises,
      cooldowns: cooldowns,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Helper method to convert old format exercise lists to WorkoutExercise objects
  List<WorkoutExercise> _convertOldFormatToExercises(
      List<dynamic> exercisesData) {
    return exercisesData.map((exerciseData) {
      Map<String, dynamic> exercise = exerciseData as Map<String, dynamic>;

      // Convert minutes and seconds to total duration in seconds
      int minutes = exercise['selectedMinutes'] ?? 0;
      int seconds = exercise['selectedSeconds'] ?? 0;
      int totalDuration = (minutes * 60) + seconds;

      // Parse reps from string to int, defaulting to 0 if conversion fails
      int reps = int.tryParse(exercise['repetition'] ?? '0') ?? 0;

      return WorkoutExercise(
        id: exercise['itemId'],
        name: exercise['name'] ?? '',
        description: exercise['description'] ?? '',
        imageUrl: exercise['image'] ?? '',
        videoUrl: exercise['videoUrl'] ?? '',
        audioUrl: exercise['audioUrl'] ?? '',
        equipment: exercise['equipment'] ?? '',
        difficulty: exercise['difficulty'] ?? '',
        topic: exercise['topic'] ?? 'Strength', // Added topic field
        sets: 1, // Default to 1 set as old format doesn't specify
        reps: reps,
        restBetweenSets:
            30, // Default to 30 seconds as old format doesn't specify
        duration: totalDuration,
        isTimeBased: totalDuration >
            0, // If duration is specified, consider it time-based
      );
    }).toList();
  }

  // Get all workouts
  Future<List<Workout>> getAllWorkouts() async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs
          .map((doc) => _convertOldFormatToWorkout(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error getting all workouts: $e');
      rethrow;
    }
  }

  // Delete a workout
  Future<void> deleteWorkout(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting workout: $e');
      rethrow;
    }
  }

  // Upload an image and return the URL with error handling for AppCheck
  Future<String> uploadImage(File file) async {
    try {
      final String fileName = '${const Uuid().v4()}.jpg';
      final Reference ref = _storage.ref().child('workout_images/$fileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );

      UploadTask uploadTask;
      if (kIsWeb) {
        // Handle web uploads
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } else {
        // Handle mobile uploads
        uploadTask = ref.putFile(file, metadata);
      }

      // Listen for state changes, errors, and completion of the upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        debugPrint(
            'Upload progress: ${snapshot.bytesTransferred / snapshot.totalBytes * 100}%');
      }, onError: (e) {
        debugPrint('Upload error: $e');
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      // Return a placeholder URL or empty string if upload fails
      return "";
    }
  }

  // Upload a video and return the URL with error handling for AppCheck
  Future<String> uploadVideo(File file) async {
    try {
      final String fileName = '${const Uuid().v4()}.mp4';
      final Reference ref = _storage.ref().child('workout_videos/$fileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {'picked-file-path': file.path},
      );

      UploadTask uploadTask;
      if (kIsWeb) {
        // Handle web uploads
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } else {
        // Handle mobile uploads
        uploadTask = ref.putFile(file, metadata);
      }

      // Listen for state changes, errors, and completion of the upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        debugPrint(
            'Upload progress: ${snapshot.bytesTransferred / snapshot.totalBytes * 100}%');
      }, onError: (e) {
        debugPrint('Upload error: $e');
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading video: $e');
      // Return a placeholder URL or empty string if upload fails
      return "";
    }
  }

  // Upload audio and return the URL with error handling for AppCheck
  Future<String> uploadAudio(File file) async {
    try {
      final String fileName = '${const Uuid().v4()}.m4a';
      final Reference ref = _storage.ref().child('workout_audio/$fileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'audio/m4a',
        customMetadata: {'picked-file-path': file.path},
      );

      UploadTask uploadTask;
      if (kIsWeb) {
        // Handle web uploads
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } else {
        // Handle mobile uploads
        uploadTask = ref.putFile(file, metadata);
      }

      // Listen for state changes, errors, and completion of the upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        debugPrint(
            'Upload progress: ${snapshot.bytesTransferred / snapshot.totalBytes * 100}%');
      }, onError: (e) {
        debugPrint('Upload error: $e');
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading audio: $e');
      // Return a placeholder URL or empty string if upload fails
      return "";
    }
  }
}
