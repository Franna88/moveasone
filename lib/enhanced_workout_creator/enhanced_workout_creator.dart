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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0), // Light Sand/Cream
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6699CC), // Cornflower Blue
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color:
                    const Color(0xFF94D8E0).withOpacity(0.3)), // Pale Turquoise
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: const Color(0xFF6699CC), width: 2), // Cornflower Blue
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF6699CC), // Cornflower Blue
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 1,
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF6699CC), // Cornflower Blue
          secondary: const Color(0xFF94D8E0), // Pale Turquoise
          tertiary: const Color(0xFFEDCBA4), // Toffee
          surface: Colors.white, // Light Sand/Cream
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
