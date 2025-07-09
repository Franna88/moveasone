import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/enhanced_workout_creator.dart';

/// This class demonstrates how to integrate the Enhanced Workout Creator
/// into the existing app. You can replace the old "New Workout" button
/// in WorkoutsColumn with a button that navigates to the enhanced workout creator.
class EnhancedWorkoutCreatorConnector {
  /// Example of how to modify WorkoutsColumn to use the enhanced workout creator
  static Widget modifyWorkoutsColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original Workout Column header and UI elements
          const Text(
            'Workouts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Replace the original "New Workout" button with this enhanced version
          ElevatedButton(
            onPressed: () {
              // Navigate to the enhanced workout creator
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnhancedWorkoutCreator(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6699CC),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('New Workout (Enhanced)'),
          ),

          // Keep other buttons from WorkoutsColumn
          const SizedBox(height: 10),
          const Text(
            'Keep your existing buttons here...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Example of a simple replacement button that can be used in the WorkoutsColumn
  static Widget enhancedWorkoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EnhancedWorkoutCreator(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6699CC),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('New Workout (Enhanced)'),
    );
  }

  /// Instructions for implementing the enhanced workout creator
  ///
  /// Option 1: Direct replacement in WorkoutsColumn
  ///
  /// 1. Open lib/admin/adminItems/adminHome/ui/workoutsColumn.dart
  /// 2. Find the "New Workout" button
  /// 3. Replace it with the enhancedWorkoutButton from this class
  ///
  /// Option 2: Add a toggle to switch between old and new workout creators
  ///
  /// 1. Add a boolean flag to control which workout creator to use
  /// 2. Use a conditional to show either the original or enhanced creator
  ///
  /// Example code for WorkoutsColumn.dart:
  ///
  /// ```dart
  /// // At the top of your WorkoutsColumnState class
  /// bool useEnhancedWorkoutCreator = true; // Set to true to use enhanced creator
  ///
  /// // In your build method, where the "New Workout" button is
  /// useEnhancedWorkoutCreator
  ///   ? EnhancedWorkoutCreatorConnector.enhancedWorkoutButton(context)
  ///   : CommonButtons(
  ///       buttonText: 'New Workout',
  ///       onTap: () {
  ///         Navigator.push(
  ///           context,
  ///           MaterialPageRoute(
  ///               builder: (context) => const WorkoutCategoryMain()),
  ///         );
  ///       },
  ///       buttonColor: AdminColors().lightTeal),
  /// ```
}
