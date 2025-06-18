# Enhanced Sets & Reps Workout System 🏋️‍♂️

## Overview

The Enhanced Sets & Reps Workout System provides comprehensive tracking and management of exercise sets, repetitions, and rest periods. This system offers a modern, interactive workout experience with visual progress tracking and automatic rest timers.

## Key Features

### 🎯 **Set & Rep Tracking**
- Visual progress indicators for each set
- Animated progress bars and pulsing current set indicators
- Real-time completion tracking
- Support for both rep-based and time-based exercises

### ⏱️ **Rest Period Management**
- Automatic rest timers between sets
- Customizable rest durations per exercise
- Skip rest functionality for advanced users
- Visual countdown with motivational messaging

### 📱 **Enhanced User Interface**
- Clean, modern design with intuitive controls
- Color-coded progress (Purple for current, Green for completed)
- Smooth animations and visual feedback
- Media integration (video/audio support)

### 🔄 **Flexible Exercise Support**
- Rep-based exercises (Push-ups, Squats, etc.)
- Time-based exercises (Planks, Wall sits, etc.)
- Mixed workout combinations
- Warm-up, main workout, and cool-down phases

## Components

### 1. **SetsAndRepsTracker**
**Location:** `lib/userSide/exerciseProcess/sceenTypes/setsAndRepsTracker.dart`

The core component that handles set completion, rep counting, and rest periods.

**Key Features:**
- Set progress visualization with circular indicators
- Animated progress bars
- Rest timer with countdown
- Exercise completion celebration

**Props:**
- `exerciseData`: Exercise configuration including sets, reps, rest time
- `onExerciseComplete`: Callback when all sets are completed
- `onStatusUpdate`: Real-time status updates

### 2. **EnhancedExerciseScreen**
**Location:** `lib/userSide/exerciseProcess/sceenTypes/enhancedExerciseScreen.dart`

Full-screen exercise interface combining media playback with sets/reps tracking.

**Key Features:**
- Video/audio media support
- Exercise image display
- Integrated sets and reps tracker
- Error handling for missing media

### 3. **EnhancedWorkoutFlow**
**Location:** `lib/userSide/exerciseProcess/enhancedWorkoutFlow.dart`

Complete workout flow manager for the enhanced system.

**Key Features:**
- Automatic workout data processing
- Phase progression (warm-up → workout → cool-down)
- Exercise completion tracking
- Workout summary on completion

## Usage

### Quick Start

```dart
import 'enhancedWorkoutFlow.dart' as enhanced;

// Start an enhanced workout
enhanced.EnhancedWorkoutStarter.startEnhancedWorkout(
  context,
  workoutData,
);
```

### Workout Data Structure

```dart
Map<String, dynamic> workoutData = {
  'name': 'Strength Training',
  'description': 'Full body workout',
  'warmUps': [
    {
      'name': 'Dynamic Warm-up',
      'sets': 1,
      'reps': 10,
      'duration': 60,
      'isTimeBased': true,
      'restBetweenSets': 15,
    }
  ],
  'workouts': [
    {
      'name': 'Push-ups',
      'sets': 3,
      'reps': 12,
      'isTimeBased': false,
      'restBetweenSets': 60,
    },
    {
      'name': 'Plank',
      'sets': 3,
      'reps': 1,
      'duration': 30,
      'isTimeBased': true,
      'restBetweenSets': 45,
    }
  ],
  'coolDowns': [
    {
      'name': 'Stretching',
      'sets': 1,
      'reps': 1,
      'duration': 120,
      'isTimeBased': true,
      'restBetweenSets': 10,
    }
  ]
};
```

### Exercise Configuration

Each exercise supports the following properties:

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `name` | String | Exercise name | Required |
| `sets` | int | Number of sets | 1 |
| `reps` | int | Repetitions per set | 1 |
| `duration` | int | Duration in seconds (for time-based) | 30 |
| `isTimeBased` | bool | Whether exercise is time-based | false |
| `restBetweenSets` | int | Rest time between sets (seconds) | 30 |
| `description` | String | Exercise instructions | '' |
| `videoUrl` | String | Video demonstration URL | '' |
| `audioUrl` | String | Audio guidance URL | '' |
| `imageUrl` | String | Exercise image URL | '' |

## Demo Usage

Access the demo from the Workout Flow Demo screen:

1. Navigate to the workout demo area
2. Tap "🏋️ Enhanced Sets & Reps Demo"
3. Experience the full workout flow with:
   - 1 Dynamic warm-up exercise
   - 5 Strength training exercises with varied sets/reps
   - 1 Cool-down stretching session

## Integration Examples

### Basic Integration

```dart
// In your workout start button
ElevatedButton(
  onPressed: () {
    enhanced.EnhancedWorkoutStarter.startEnhancedWorkout(
      context,
      myWorkoutData,
    );
  },
  child: Text('Start Workout'),
)
```

### Custom Exercise Screen

```dart
EnhancedExerciseScreen(
  exerciseData: {
    'name': 'Push-ups',
    'sets': 3,
    'reps': 12,
    'restBetweenSets': 60,
    'isTimeBased': false,
    'setTotal': '3',
    'repsTotal': '12',
  },
  onComplete: () {
    // Move to next exercise
  },
  onStatusUpdate: (status) {
    print('Exercise status: $status');
  },
)
```

## State Management

The system automatically manages:

- **Current Set**: Which set the user is currently performing
- **Completed Sets**: How many sets have been finished
- **Rest State**: Whether the user is in a rest period
- **Exercise Progress**: Overall progress through the workout
- **Phase Tracking**: Current workout phase (warm-up/workout/cool-down)

## Visual Design

### Color Coding
- **Purple**: Current/active set
- **Green**: Completed sets/exercises
- **Blue**: Rest periods
- **Orange**: Optional actions (skip rest)
- **Grey**: Inactive/upcoming sets

### Animations
- **Pulse Animation**: Current set indicator pulses to draw attention
- **Progress Animation**: Smooth progress bar updates
- **Completion Animation**: Celebration effects when sets are completed

## Error Handling

The system gracefully handles:
- Missing or invalid media URLs
- Malformed exercise data
- Network connectivity issues
- User navigation interruptions

## Performance Considerations

- **Efficient Animations**: Uses hardware-accelerated animations
- **Memory Management**: Properly disposes of video/audio players
- **Lazy Loading**: Media is loaded only when needed
- **State Cleanup**: Automatic timer cleanup on component disposal

## Future Enhancements

Planned improvements include:
- **Weight Tracking**: Log weights used for exercises
- **Rep Counting**: Automatic rep detection via device sensors
- **Voice Commands**: Hands-free set completion
- **Progress Analytics**: Detailed workout statistics
- **Social Features**: Share workout achievements

## Troubleshooting

### Common Issues

**Sets not progressing?**
- Ensure `setTotal` and `repsTotal` are properly set as strings
- Check that `onExerciseComplete` callback is provided

**Rest timer not working?**
- Verify `restBetweenSets` is set as a number (not string)
- Check that Timer is properly initialized

**Media not playing?**
- Ensure URLs are valid and accessible
- Check internet connectivity
- Verify media format compatibility

### Debug Output

Enable debug prints by checking console for:
- `DEBUG: SetsAndRepsTracker initialized`
- `DEBUG: Enhanced Workout Flow - Processing workout data`
- `DEBUG: Media mode determined`

## Support

For questions or issues with the Enhanced Sets & Reps system, check:
1. Console debug output
2. Exercise data structure validation
3. Media URL accessibility
4. Network connectivity

The system provides comprehensive logging to help identify and resolve issues quickly. 