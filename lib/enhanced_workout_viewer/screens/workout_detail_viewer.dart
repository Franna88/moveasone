import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/enhanced_workout_viewer/models/workout_model.dart';
import 'package:move_as_one/enhanced_workout_viewer/services/workout_service.dart';
import 'package:move_as_one/enhanced_workout_viewer/widgets/exercise_card.dart';
import 'package:move_as_one/userSide/exerciseProcess/workoutFlowManager.dart';

class WorkoutDetailViewer extends StatefulWidget {
  final String workoutId;
  final String userType;

  const WorkoutDetailViewer({
    Key? key,
    required this.workoutId,
    required this.userType,
  }) : super(key: key);

  @override
  State<WorkoutDetailViewer> createState() => _WorkoutDetailViewerState();
}

class _WorkoutDetailViewerState extends State<WorkoutDetailViewer> {
  final WorkoutViewerService _workoutService = WorkoutViewerService();
  late Future<WorkoutModel?> _workoutFuture;
  int _currentTab = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _workoutFuture = _fetchWorkout();
  }

  Future<WorkoutModel?> _fetchWorkout() async {
    try {
      return await _workoutService.getWorkoutById(widget.workoutId);
    } catch (e) {
      debugPrint('Error fetching workout: $e');
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startWorkout(BuildContext context, WorkoutModel workout) {
    // Convert workout model to the format expected by WorkoutFlowManager
    Map<String, dynamic> entireExercise = {
      "name": workout.name,
      "description": workout.description,
      "warmUps": workout.warmups.map((e) {
        // Ensure repetition is a string (not null)
        String repetition = e.repetition.isNotEmpty ? e.repetition : "1";

        return {
          ...e.toJson(),
          "repetition": repetition,
          "image": e.imageUrl.isNotEmpty
              ? e.imageUrl
              : "https://via.placeholder.com/150",
          "videoUrl": e.videoUrl.isNotEmpty ? e.videoUrl : "",
          "audioUrl": e.audioUrl.isNotEmpty ? e.audioUrl : "",
          "selectedMinutes": e.selectedMinutes,
          "selectedSeconds": e.selectedSeconds,
          "description": e.description.isNotEmpty
              ? e.description
              : "No description available",
          "name": e.name.isNotEmpty ? e.name : "Exercise",
        };
      }).toList(),
      "workouts": workout.exercises.map((e) {
        // Ensure repetition is a string (not null)
        String repetition = e.repetition.isNotEmpty ? e.repetition : "1";

        return {
          ...e.toJson(),
          "repetition": repetition,
          "image": e.imageUrl.isNotEmpty
              ? e.imageUrl
              : "https://via.placeholder.com/150",
          "videoUrl": e.videoUrl.isNotEmpty ? e.videoUrl : "",
          "audioUrl": e.audioUrl.isNotEmpty ? e.audioUrl : "",
          "selectedMinutes": e.selectedMinutes,
          "selectedSeconds": e.selectedSeconds,
          "description": e.description.isNotEmpty
              ? e.description
              : "No description available",
          "name": e.name.isNotEmpty ? e.name : "Exercise",
        };
      }).toList(),
      "coolDowns": workout.cooldowns.map((e) {
        // Ensure repetition is a string (not null)
        String repetition = e.repetition.isNotEmpty ? e.repetition : "1";

        return {
          ...e.toJson(),
          "repetition": repetition,
          "image": e.imageUrl.isNotEmpty
              ? e.imageUrl
              : "https://via.placeholder.com/150",
          "videoUrl": e.videoUrl.isNotEmpty ? e.videoUrl : "",
          "audioUrl": e.audioUrl.isNotEmpty ? e.audioUrl : "",
          "selectedMinutes": e.selectedMinutes,
          "selectedSeconds": e.selectedSeconds,
          "description": e.description.isNotEmpty
              ? e.description
              : "No description available",
          "name": e.name.isNotEmpty ? e.name : "Exercise",
        };
      }).toList(),
      "bodyArea": workout.bodyArea.isNotEmpty ? workout.bodyArea : "General",
      "displayImage": workout.imageUrl.isNotEmpty
          ? workout.imageUrl
          : "https://via.placeholder.com/150",
      "imageUrl": workout.imageUrl.isNotEmpty
          ? workout.imageUrl
          : "https://via.placeholder.com/150",
      "restTime": workout.duration > 0 ? workout.duration : 30,
      "estimatedDuration": workout.duration,
    };

    // Use the enhanced workout starter
    EnhancedWorkoutStarter.startWorkout(context, entireExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WorkoutModel?>(
        future: _workoutFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading workout',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _workoutFuture = _fetchWorkout();
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final workout = snapshot.data;
          if (workout == null) {
            return const Center(
              child: Text('Workout not found'),
            );
          }

          return _buildWorkoutDetails(context, workout);
        },
      ),
    );
  }

  Widget _buildWorkoutDetails(BuildContext context, WorkoutModel workout) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, workout),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBanner(context, workout),
              _buildDescription(context, workout),
              _buildTabBar(context),
            ],
          ),
        ),
        _buildExerciseList(context, workout),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _startWorkout(context, workout),
              style: ElevatedButton.styleFrom(
                backgroundColor: UiColors().brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 54),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_fill, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'START WORKOUT',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, WorkoutModel workout) {
    final bool hasValidImage = workout.imageUrl.isNotEmpty &&
        (workout.imageUrl.startsWith('http://') ||
            workout.imageUrl.startsWith('https://'));

    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      stretch: true,
      backgroundColor: UiColors().teal,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image or placeholder
            hasValidImage
                ? Image.network(
                    workout.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading workout image: $error');
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.fitness_center,
                              size: 64, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.fitness_center,
                          size: 64, color: Colors.grey),
                    ),
                  ),
            // Gradient overlay for better text visibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workout.bodyArea,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, color: Colors.white),
          ),
          onPressed: () {
            // TODO: Add to favorites
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildInfoBanner(BuildContext context, WorkoutModel workout) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoItem(
            context,
            Icons.timer_outlined,
            '${workout.duration} min',
            'Duration',
          ),
          const SizedBox(width: 8),
          _buildInfoItem(
            context,
            Icons.fitness_center,
            workout.difficulty,
            'Difficulty',
          ),
          const SizedBox(width: 8),
          _buildInfoItem(
            context,
            Icons.category_outlined,
            workout.equipment.isNotEmpty ? workout.equipment.first : 'None',
            'Equipment',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: UiColors().brown, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context, WorkoutModel workout) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            workout.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabButton(context, 'Warm-up', 0),
          _buildTabButton(context, 'Workout', 1),
          _buildTabButton(context, 'Cool-down', 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, int index) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? UiColors().brown : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context, WorkoutModel workout) {
    List<ExerciseModel> exercises;

    switch (_currentTab) {
      case 0:
        exercises = workout.warmups;
        break;
      case 1:
        exercises = workout.exercises;
        break;
      case 2:
        exercises = workout.cooldowns;
        break;
      default:
        exercises = workout.exercises;
    }

    if (exercises.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fitness_center,
                    size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No exercises added yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final exercise = exercises[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ExerciseCard(
                exercise: exercise,
                index: index + 1,
                onTap: () {
                  // TODO: Show exercise details
                },
              ),
            );
          },
          childCount: exercises.length,
        ),
      ),
    );
  }
}
