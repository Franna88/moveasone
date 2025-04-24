import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_model.dart';
import 'package:move_as_one/enhanced_workout_creator/screens/exercise_editor_screen.dart';
import 'package:move_as_one/enhanced_workout_creator/services/workout_service.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/exercise_card.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_app_bar.dart';
import 'package:move_as_one/enhanced_workout_creator/widgets/modern_button.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    Key? key,
    required this.workoutId,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final WorkoutService _workoutService = WorkoutService();
  Workout? _workout;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWorkout();
  }

  Future<void> _loadWorkout() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final workout = await _workoutService.getWorkout(widget.workoutId);
      setState(() {
        _workout = workout;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load workout: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addExercise(String type) async {
    if (_workout == null) return;

    final result = await Navigator.push<WorkoutExercise>(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseEditorScreen(
          workoutId: widget.workoutId,
          exerciseType: type,
        ),
      ),
    );

    if (result != null) {
      // Exercise was added, reload the workout
      await _loadWorkout();
    }
  }

  Future<void> _editExercise(String type, WorkoutExercise exercise) async {
    if (_workout == null) return;

    final result = await Navigator.push<WorkoutExercise>(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseEditorScreen(
          workoutId: widget.workoutId,
          exerciseType: type,
          exercise: exercise,
        ),
      ),
    );

    if (result != null) {
      // Exercise was edited, reload the workout
      await _loadWorkout();
    }
  }

  Future<void> _deleteExercise(String type, String exerciseId) async {
    if (_workout == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<WorkoutExercise> exercises;

      switch (type) {
        case 'warmup':
          exercises = List.from(_workout!.warmups);
          exercises.removeWhere((e) => e.id == exerciseId);
          _workout = _workout!.copyWith(warmups: exercises);
          break;
        case 'exercise':
          exercises = List.from(_workout!.exercises);
          exercises.removeWhere((e) => e.id == exerciseId);
          _workout = _workout!.copyWith(exercises: exercises);
          break;
        case 'cooldown':
          exercises = List.from(_workout!.cooldowns);
          exercises.removeWhere((e) => e.id == exerciseId);
          _workout = _workout!.copyWith(cooldowns: exercises);
          break;
      }

      await _workoutService.updateWorkout(_workout!);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise deleted successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete exercise: $e')),
      );
    }
  }

  void _showDeleteConfirmation(String type, WorkoutExercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exercise'),
        content: Text(
          'Are you sure you want to delete "${exercise.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              _deleteExercise(type, exercise.id);
              Navigator.pop(context);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: ModernAppBar(
        title: _workout?.name ?? 'Workout Detail',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWorkout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _workout == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage.isEmpty
                            ? 'Workout not found'
                            : _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ModernButton(
                        text: 'Go Back',
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.arrow_back,
                      ),
                    ],
                  ),
                )
              : _buildWorkoutDetail(),
    );
  }

  Widget _buildWorkoutDetail() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutHeader(),
          const SizedBox(height: 24),
          _buildSectionHeader('Warm-up Exercises', 'warmup'),
          ..._buildExerciseList('warmup', _workout!.warmups),
          const SizedBox(height: 24),
          _buildSectionHeader('Main Exercises', 'exercise'),
          ..._buildExerciseList('exercise', _workout!.exercises),
          const SizedBox(height: 24),
          _buildSectionHeader('Cool-down Exercises', 'cooldown'),
          ..._buildExerciseList('cooldown', _workout!.cooldowns),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_workout!.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                _workout!.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _workout!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _workout!.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      Icons.fitness_center,
                      'Level',
                      _workout!.difficulty,
                    ),
                    _buildInfoItem(
                      Icons.timer,
                      'Duration',
                      '${_workout!.estimatedDuration} min',
                    ),
                    _buildInfoItem(
                      Icons.format_list_numbered,
                      'Exercises',
                      '${_workout!.warmups.length + _workout!.exercises.length + _workout!.cooldowns.length}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _workout!.categories
                      .map(
                        (category) => Chip(
                          label: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Body Areas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _workout!.bodyAreas
                      .map(
                        (area) => Chip(
                          label: Text(
                            area,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.teal,
                        ),
                      )
                      .toList(),
                ),
                if (_workout!.equipment.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Equipment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _workout!.equipment
                        .map(
                          (equipment) => Chip(
                            label: Text(
                              equipment,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.amber.shade800,
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Scheduled Days',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _workout!.weekdays
                      .map(
                        (day) => Chip(
                          label: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.blue.shade600,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).primaryColor,
          onPressed: () => _addExercise(type),
          tooltip: 'Add $title',
        ),
      ],
    );
  }

  List<Widget> _buildExerciseList(
      String type, List<WorkoutExercise> exercises) {
    if (exercises.isEmpty) {
      return [
        Card(
          elevation: 0,
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 150,
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No exercises added yet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _addExercise(type),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      'Add Exercise',
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: const Size(120, 36),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    return exercises
        .asMap()
        .entries
        .map(
          (entry) => ExerciseCard(
            exercise: entry.value,
            index: entry.key,
            onEdit: () => _editExercise(type, entry.value),
            onDelete: () => _showDeleteConfirmation(type, entry.value),
          ),
        )
        .toList();
  }
}
