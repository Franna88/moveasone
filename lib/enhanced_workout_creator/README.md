# Enhanced Workout Creator

A modern, feature-rich workout creation module that can be used as a drop-in replacement for the existing workout creator in the Move As One app.

## Features

- Modern UI with a clean, user-friendly design
- Comprehensive workout details including categories, body areas, equipment
- Support for warmup, main exercises, and cooldown routines
- Detailed exercise configuration with sets, reps, and rest periods
- Time-based or repetition-based exercise options
- Media support including images, videos, and audio instructions
- Standalone mode for testing and development

## Folder Structure

```
enhanced_workout_creator/
├── models/
│   ├── workout_model.dart       # Data models for workouts and exercises
│   └── workout_constants.dart   # Constants for categories, equipment, etc.
├── screens/
│   ├── workout_list_screen.dart     # List of all workouts
│   ├── create_workout_screen.dart   # Create new workout details
│   ├── workout_detail_screen.dart   # View/edit workout details
│   └── exercise_editor_screen.dart  # Add/edit exercises
├── services/
│   └── workout_service.dart     # Firestore operations
├── widgets/
│   ├── modern_app_bar.dart      # Custom app bar
│   ├── modern_button.dart       # Custom buttons
│   ├── modern_input_field.dart  # Custom input fields
│   ├── multi_select_chip.dart   # Selection widgets
│   └── exercise_card.dart       # Exercise display card
├── enhanced_workout_creator.dart # Main entry point
├── connector.dart               # Integration helper
└── README.md                    # Documentation
```

## Integration

### Option 1: Standalone Mode

For testing and development, you can run the enhanced workout creator as a standalone app:

```dart
import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/enhanced_workout_creator.dart';

void main() {
  runApp(const EnhancedWorkoutCreatorStandalone());
}
```

### Option 2: Direct Integration

To integrate with the existing app, you can modify the `WorkoutsColumn` widget:

1. Open `lib/admin/adminItems/adminHome/ui/workoutsColumn.dart`
2. Import the connector: 
   ```dart
   import 'package:move_as_one/enhanced_workout_creator/connector.dart';
   ```
3. Replace the "New Workout" button with:
   ```dart
   EnhancedWorkoutCreatorConnector.enhancedWorkoutButton(context)
   ```

### Option 3: Toggle Between Old and New

Add a toggle to switch between the old and new workout creators:

```dart
// At the top of your WorkoutsColumnState class
bool useEnhancedWorkoutCreator = true; // Set to true to use enhanced creator

// In your build method, where the "New Workout" button is
useEnhancedWorkoutCreator
  ? EnhancedWorkoutCreatorConnector.enhancedWorkoutButton(context)
  : CommonButtons(
      buttonText: 'New Workout',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WorkoutCategoryMain()),
        );
      },
      buttonColor: AdminColors().lightTeal),
```

## Workflow

1. Users start by selecting "New Workout" which takes them to the enhanced workout creator
2. They fill in basic workout details (name, description, categories, etc.)
3. After creating the workout, they can add exercises in three categories:
   - Warmup exercises
   - Main exercises
   - Cooldown exercises
4. For each exercise, they can specify:
   - Name and description
   - Difficulty level and required equipment
   - Sets, repetitions, and rest periods
   - Time-based or repetition-based options
   - Media (images, videos, audio instructions)
5. All data is saved to the same Firestore database structure, ensuring compatibility with the rest of the app

## Customization

The enhanced workout creator uses a consistent theme that can be customized in `enhanced_workout_creator.dart`. You can modify colors, shapes, and other visual elements to match your app's design.

## Dependencies

- Flutter SDK
- Firebase Firestore
- Firebase Storage
- image_picker: For selecting images and videos
- uuid: For generating unique IDs 