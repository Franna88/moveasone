import 'package:flutter/material.dart';

class WorkoutStartScreen extends StatefulWidget {
  final Map entireExercise;
  final Function() onStartWorkout;

  const WorkoutStartScreen({
    super.key,
    required this.entireExercise,
    required this.onStartWorkout,
  });

  @override
  State<WorkoutStartScreen> createState() => _WorkoutStartScreenState();
}

class _WorkoutStartScreenState extends State<WorkoutStartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int totalWarmups = 0;
  int totalWorkouts = 0;
  int totalCooldowns = 0;
  int estimatedDuration = 0;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _calculateWorkoutStats();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  void _calculateWorkoutStats() {
    // Count warm-ups
    if (widget.entireExercise['warmUps'] != null &&
        widget.entireExercise['warmUps'] is List) {
      totalWarmups = widget.entireExercise['warmUps'].length;
      estimatedDuration += totalWarmups * 2; // Assume 2 minutes per warm-up
    }

    // Count main workouts
    if (widget.entireExercise['workouts'] != null &&
        widget.entireExercise['workouts'] is List) {
      totalWorkouts = widget.entireExercise['workouts'].length;
      estimatedDuration += totalWorkouts * 3; // Assume 3 minutes per exercise
    } else if (widget.entireExercise['exercises'] != null &&
        widget.entireExercise['exercises'] is List) {
      totalWorkouts = widget.entireExercise['exercises'].length;
      estimatedDuration += totalWorkouts * 3;
    }

    // Count cool-downs
    if (widget.entireExercise['coolDowns'] != null &&
        widget.entireExercise['coolDowns'] is List) {
      totalCooldowns = widget.entireExercise['coolDowns'].length;
      estimatedDuration += totalCooldowns * 2; // Assume 2 minutes per cool-down
    } else if (widget.entireExercise['cooldowns'] != null &&
        widget.entireExercise['cooldowns'] is List) {
      totalCooldowns = widget.entireExercise['cooldowns'].length;
      estimatedDuration += totalCooldowns * 2;
    }

    // Use provided duration if available
    if (widget.entireExercise['estimatedDuration'] != null) {
      estimatedDuration = widget.entireExercise['estimatedDuration'];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 28,
                        ),
                        const Spacer(),
                        // Simple test button
                        ElevatedButton(
                          onPressed: () {
                            print('DEBUG: Simple test button works!');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Test button works!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('TEST'),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${estimatedDuration}min',
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                      widget.entireExercise['name'] ?? 'Your Workout',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      widget.entireExercise['description'] ??
                          'Get ready for your workout!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Workout Structure
                    const Text(
                      'Workout Structure',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Scrollable content area
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (totalWarmups > 0)
                              _buildPhaseCard(
                                title: 'Warm Up',
                                subtitle:
                                    '$totalWarmups exercise${totalWarmups > 1 ? 's' : ''}',
                                icon: Icons.local_fire_department,
                                color: Colors.orange,
                                description:
                                    'Prepare your body for the workout',
                              ),
                            if (totalWorkouts > 0)
                              _buildPhaseCard(
                                title: 'Main Workout',
                                subtitle:
                                    '$totalWorkouts exercise${totalWorkouts > 1 ? 's' : ''}',
                                icon: Icons.fitness_center,
                                color: Colors.red,
                                description:
                                    'Push your limits and get stronger',
                              ),
                            if (totalCooldowns > 0)
                              _buildPhaseCard(
                                title: 'Cool Down',
                                subtitle:
                                    '$totalCooldowns exercise${totalCooldowns > 1 ? 's' : ''}',
                                icon: Icons.spa,
                                color: Colors.blue,
                                description: 'Relax and recover properly',
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Fixed Start Workout Button at bottom
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isButtonPressed
                            ? null
                            : () {
                                print('DEBUG: START WORKOUT button pressed!');
                                setState(() {
                                  _isButtonPressed = true;
                                });

                                // Call the callback
                                widget.onStartWorkout();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonPressed
                              ? Colors.grey
                              : Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 4,
                        ),
                        child: _isButtonPressed
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'STARTING...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'START WORKOUT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhaseCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
