import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/workout_list_screen.dart';

class EnhancedWorkoutCreator extends StatelessWidget {
  const EnhancedWorkoutCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WorkoutListScreen();
  }
}

// This function can be used to wrap the enhanced workout creator in a new Material App
// for standalone testing or development
class EnhancedWorkoutCreatorStandalone extends StatelessWidget {
  const EnhancedWorkoutCreatorStandalone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Workout Creator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          fillColor: Colors.grey.shade50,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.deepOrange,
        ),
      ),
      home: const EnhancedWorkoutCreator(),
    );
  }
}

// Example of how to use this with a main function for standalone execution
/*
void main() {
  runApp(const EnhancedWorkoutCreatorStandalone());
}
*/ 