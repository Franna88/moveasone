import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/Services/motivation_service.dart';

/// A utility class for scheduled tasks in the app
///
/// This is a client-side implementation for demo purposes.
/// In a production environment, these functions would run
/// on Firebase Cloud Functions or another server-side solution.
class ScheduledTasks {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Run daily motivation calculation for all users
  ///
  /// Check if it's been 24+ hours since the last calculation,
  /// if yes, trigger a recalculation for all users
  static Future<void> checkAndUpdateMotivation() async {
    try {
      // Get the last calculation time
      final doc = await _firestore
          .collection('appSettings')
          .doc('motivationCalculation')
          .get();

      if (!doc.exists) {
        // First time running, create the document and run calculation
        await _runMotivationUpdate();
        return;
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp lastCalc = data['lastRun'] as Timestamp;
      DateTime lastCalcTime = lastCalc.toDate();
      DateTime now = DateTime.now();

      // If more than 24 hours have passed since last calculation
      if (now.difference(lastCalcTime).inHours >= 24) {
        await _runMotivationUpdate();
      }
    } catch (e) {
      print('Error checking motivation update schedule: $e');
    }
  }

  /// Run the motivation update for all users and update the timestamp
  static Future<void> _runMotivationUpdate() async {
    try {
      // Update all users' motivation scores
      await MotivationService.updateAllUsersMotivation();

      // Update the last run timestamp
      await _firestore
          .collection('appSettings')
          .doc('motivationCalculation')
          .set({
        'lastRun': FieldValue.serverTimestamp(),
        'status': 'success',
      });

      print('Scheduled motivation update completed successfully');
    } catch (e) {
      // Log the error but don't rethrow
      print('Error running scheduled motivation update: $e');

      // Update with error status
      await _firestore
          .collection('appSettings')
          .doc('motivationCalculation')
          .set({
        'lastRun': FieldValue.serverTimestamp(),
        'status': 'error',
        'error': e.toString(),
      });
    }
  }

  /// Force a manual recalculation of all motivation scores
  static Future<void> forceRecalculation() async {
    await _runMotivationUpdate();
  }
}
