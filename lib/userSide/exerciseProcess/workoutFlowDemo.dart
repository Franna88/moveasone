import 'package:flutter/material.dart';
import 'workoutFlowManager.dart';
import 'enhancedWorkoutFlow.dart' as enhanced;

class WorkoutFlowDemo extends StatelessWidget {
  const WorkoutFlowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Workout Flow Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enhanced Workout Flow',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This demo shows the new workout flow that includes:\n'
              '• Workout overview screen\n'
              '• Phase transitions (Warm-up → Workout → Cool-down)\n'
              '• Progress indicators\n'
              '• Enhanced user experience',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Sample workout buttons
            _buildWorkoutButton(
              context,
              title: 'Full Workout (All Phases)',
              description: 'Warm-up, Main workout, and Cool-down',
              workout: _createFullWorkout(),
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 16),

            _buildWorkoutButton(
              context,
              title: 'Main Workout Only',
              description: 'Just the main exercises',
              workout: _createMainWorkoutOnly(),
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            _buildWorkoutButton(
              context,
              title: 'Quick Warm-up',
              description: 'Just warm-up exercises',
              workout: _createWarmupOnly(),
              color: Colors.orange,
            ),

            const SizedBox(height: 16),

            // Enhanced Sets & Reps Demo
            ElevatedButton(
              onPressed: () {
                enhanced.EnhancedWorkoutStarter.startEnhancedWorkout(
                  context,
                  _createSetsAndRepsWorkout(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '🏋️ Enhanced Sets & Reps Demo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Debug Test Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Debug Test',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use this to test if the button works at all',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      print('DEBUG: Simple test button pressed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Test button works! Check console for debug output.'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Test with minimal data
                      Map<String, dynamic> testWorkout = {
                        'name': 'Simple Test',
                        'description': 'Testing button responsiveness',
                        'workouts': [
                          {
                            'name': 'Test Exercise',
                            'description': 'Simple test',
                            'sets': 1,
                            'reps': 1,
                            'duration': 10,
                            'isTimeBased': true,
                            'restBetweenSets': 5,
                          }
                        ]
                      };

                      EnhancedWorkoutStarter.startWorkout(context, testWorkout);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Button Responsiveness'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutButton(
    BuildContext context, {
    required String title,
    required String description,
    required Map<String, dynamic> workout,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {
        EnhancedWorkoutStarter.startWorkout(context, workout);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _createFullWorkout() {
    return {
      'name': 'Complete Full Body Workout',
      'description':
          'A comprehensive workout targeting all muscle groups with proper warm-up and cool-down phases.',
      'displayImage':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'imageUrl':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'estimatedDuration': 45,
      'warmUps': [
        {
          'name': 'Arm Circles',
          'description': 'Gentle arm circles to warm up shoulders',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 10,
          'duration': 60,
          'isTimeBased': true,
          'restBetweenSets': 15,
        },
        {
          'name': 'Leg Swings',
          'description': 'Dynamic leg swings to prepare lower body',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 15,
          'duration': 90,
          'isTimeBased': true,
          'restBetweenSets': 15,
        },
      ],
      'workouts': [
        {
          'name': 'Push-ups',
          'description': 'Classic push-ups for upper body strength',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 12,
          'duration': 30,
          'isTimeBased': false,
          'restBetweenSets': 60,
        },
        {
          'name': 'Squats',
          'description': 'Bodyweight squats for leg strength',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 15,
          'duration': 45,
          'isTimeBased': false,
          'restBetweenSets': 60,
        },
        {
          'name': 'Plank',
          'description': 'Core strengthening plank hold',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 1,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 45,
        },
      ],
      'coolDowns': [
        {
          'name': 'Chest Stretch',
          'description': 'Gentle chest and shoulder stretch',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 1,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 10,
        },
        {
          'name': 'Hamstring Stretch',
          'description': 'Relaxing hamstring stretch',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 1,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 10,
        },
      ],
    };
  }

  Map<String, dynamic> _createMainWorkoutOnly() {
    return {
      'name': 'Quick HIIT Session',
      'description':
          'High-intensity interval training for maximum results in minimum time.',
      'displayImage':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'imageUrl':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'estimatedDuration': 20,
      'warmUps': [],
      'workouts': [
        {
          'name': 'Burpees',
          'description': 'Full body explosive movement',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 4,
          'reps': 8,
          'duration': 30,
          'isTimeBased': false,
          'restBetweenSets': 45,
        },
        {
          'name': 'Mountain Climbers',
          'description': 'Fast-paced cardio and core exercise',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 4,
          'reps': 1,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 30,
        },
        {
          'name': 'Jump Squats',
          'description': 'Explosive squat jumps',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 4,
          'reps': 10,
          'duration': 30,
          'isTimeBased': false,
          'restBetweenSets': 45,
        },
      ],
      'coolDowns': [],
    };
  }

  Map<String, dynamic> _createWarmupOnly() {
    return {
      'name': 'Morning Mobility',
      'description':
          'Gentle movements to start your day and prepare your body.',
      'displayImage':
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
      'imageUrl':
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
      'estimatedDuration': 10,
      'warmUps': [
        {
          'name': 'Neck Rolls',
          'description': 'Gentle neck mobility',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 5,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 10,
        },
        {
          'name': 'Shoulder Shrugs',
          'description': 'Release shoulder tension',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 10,
          'duration': 30,
          'isTimeBased': false,
          'restBetweenSets': 10,
        },
        {
          'name': 'Hip Circles',
          'description': 'Loosen up your hips',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 8,
          'duration': 45,
          'isTimeBased': true,
          'restBetweenSets': 10,
        },
        {
          'name': 'Ankle Rolls',
          'description': 'Prepare your ankles for movement',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 8,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 5,
        },
      ],
      'workouts': [],
      'coolDowns': [],
    };
  }

  Map<String, dynamic> _createSetsAndRepsWorkout() {
    return {
      'name': 'Sets & Reps Strength Training',
      'description':
          'A comprehensive strength workout demonstrating advanced sets and reps tracking with rest periods.',
      'displayImage':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'imageUrl':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'estimatedDuration': 35,
      'warmUps': [
        {
          'name': 'Dynamic Warm-up',
          'description': 'Light movement to prepare your muscles',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 10,
          'duration': 60,
          'isTimeBased': true,
          'restBetweenSets': 15,
        },
      ],
      'workouts': [
        {
          'name': 'Push-ups',
          'description':
              'Classic upper body exercise focusing on chest, shoulders, and triceps',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 12,
          'duration': 30,
          'isTimeBased': false,
          'restBetweenSets': 60,
        },
        {
          'name': 'Squats',
          'description':
              'Lower body powerhouse targeting quads, glutes, and hamstrings',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 4,
          'reps': 15,
          'duration': 45,
          'isTimeBased': false,
          'restBetweenSets': 90,
        },
        {
          'name': 'Plank Hold',
          'description': 'Core strengthening isometric exercise',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 1,
          'duration': 45,
          'isTimeBased': true,
          'restBetweenSets': 60,
        },
        {
          'name': 'Lunges',
          'description': 'Unilateral leg exercise for balance and strength',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 10, // per leg
          'duration': 30,
          'isTimeBased': false,
          'restBetweenSets': 75,
        },
        {
          'name': 'Wall Sit',
          'description': 'Isometric quad and glute endurance challenge',
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 3,
          'reps': 1,
          'duration': 30,
          'isTimeBased': true,
          'restBetweenSets': 45,
        },
      ],
      'coolDowns': [
        {
          'name': 'Full Body Stretch',
          'description': 'Gentle stretching to help recovery and flexibility',
          'imageUrl':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
          'videoUrl': '',
          'audioUrl': '',
          'sets': 1,
          'reps': 1,
          'duration': 120,
          'isTimeBased': true,
          'restBetweenSets': 10,
        },
      ],
    };
  }
}
