import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MotivationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates a user's motivation score based on workout completion frequency
  static Future<void> updateUserMotivation(String uid) async {
    try {
      // Get the current date
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);

      // Get user's completed workouts from the past 14 days
      final twoWeeksAgo = now.subtract(const Duration(days: 14));

      final workoutsSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('status', isEqualTo: 'completed')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(twoWeeksAgo))
          .get();

      // Calculate days since last workout
      int daysSinceLastWorkout = 14; // Default to max days
      DateTime? lastWorkoutDate;

      // Also check the userExercises array for workout data
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> userExercises = userData['userExercises'] ?? [];

      // Extract dates from workouts collection
      List<DateTime> workoutDates = [];
      for (var doc in workoutsSnapshot.docs) {
        final workoutDate = DateFormat('yyyy-MM-dd').parse(doc['date']);
        workoutDates.add(workoutDate);
      }

      // Extract dates from userExercises array
      for (var exercise in userExercises) {
        if (exercise['date'] != null) {
          try {
            final exerciseDate = DateTime.parse(exercise['date']);
            workoutDates.add(exerciseDate);
          } catch (e) {
            print('Error parsing date from exercise: $e');
          }
        }
      }

      // Find the most recent workout date
      if (workoutDates.isNotEmpty) {
        lastWorkoutDate = workoutDates.reduce((a, b) => a.isAfter(b) ? a : b);
        daysSinceLastWorkout = now.difference(lastWorkoutDate).inDays;
      }

      // Calculate workout frequency (workouts per week)
      final totalWorkouts = workoutDates.length;
      final workoutsPerWeek = (totalWorkouts / 2.0); // 2 weeks period

      // Calculate motivation score (100 max)
      // Formula: Base 40 points + up to 40 points for frequency + up to 20 points for recency
      int motivationScore = 40; // Base score

      // Add points for frequency (up to 40)
      motivationScore += (workoutsPerWeek * 10).round().clamp(0, 40);

      // Add points for recency (up to 20)
      if (daysSinceLastWorkout <= 1) {
        motivationScore += 20; // Worked out today or yesterday
      } else if (daysSinceLastWorkout <= 3) {
        motivationScore += 15; // Within last 3 days
      } else if (daysSinceLastWorkout <= 5) {
        motivationScore += 10; // Within last 5 days
      } else if (daysSinceLastWorkout <= 7) {
        motivationScore += 5; // Within last week
      }

      // Check if user should be automatically watched based on inactivity or low motivation
      bool shouldBeWatched = false;
      String watchReason = '';

      // Auto-watch users inactive for 6+ days
      if (daysSinceLastWorkout >= 6) {
        shouldBeWatched = true;
        watchReason = 'Inactive for $daysSinceLastWorkout days';
      }

      // Auto-watch users with low motivation score (below 30)
      if (motivationScore < 30) {
        shouldBeWatched = true;
        watchReason = watchReason.isEmpty
            ? 'Low motivation score: $motivationScore'
            : '$watchReason, low motivation score: $motivationScore';
      }

      // Update the user's motivation score in Firestore
      Map<String, dynamic> updateData = {
        'motivationScore': motivationScore,
        'lastCalculated': today,
        'daysSinceLastWorkout': daysSinceLastWorkout,
        'lastWorkoutDate': lastWorkoutDate != null
            ? Timestamp.fromDate(lastWorkoutDate)
            : null,
      };

      // Only update isWatched if the user should be watched and isn't already
      if (shouldBeWatched && !(userData['isWatched'] ?? false)) {
        updateData['isWatched'] = true;
        updateData['watchReason'] = watchReason;
        updateData['watchedSince'] = FieldValue.serverTimestamp();

        // Create notification for admin
        await _createWatchNotification(
            uid, userData['name'] ?? 'Unknown user', watchReason);
      }

      await _firestore.collection('users').doc(uid).update(updateData);

      print('Updated motivation score for user $uid: $motivationScore');
    } catch (e) {
      print('Error updating motivation score: $e');
    }
  }

  /// Create a notification for admins when a user is added to the watch list
  static Future<void> _createWatchNotification(
      String userId, String userName, String reason) async {
    try {
      await _firestore.collection('adminNotifications').add({
        'type': 'user_watched',
        'userId': userId,
        'userName': userName,
        'reason': reason,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating watch notification: $e');
    }
  }

  /// Batch updates motivation scores for all users
  static Future<void> updateAllUsersMotivation() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();

      for (var user in usersSnapshot.docs) {
        await updateUserMotivation(user.id);
      }

      print('Updated motivation scores for all users');
    } catch (e) {
      print('Error in batch motivation update: $e');
    }
  }

  /// Get all admin notifications
  static Stream<QuerySnapshot> getAdminNotifications() {
    return _firestore
        .collection('adminNotifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
