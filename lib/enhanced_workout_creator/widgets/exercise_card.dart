import 'package:flutter/material.dart';
import 'package:move_as_one/enhanced_workout_creator/models/workout_model.dart';

class ExerciseCard extends StatelessWidget {
  final WorkoutExercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onView;
  final bool showControls;
  final int index;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
    this.onView,
    this.showControls = true,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                if (exercise.imageUrl.isNotEmpty)
                  Image.network(
                    exercise.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            Icons.fitness_center,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (exercise.videoUrl.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      icon: Icons.fitness_center,
                      label: exercise.isTimeBased
                          ? '${exercise.duration}s'
                          : '${exercise.reps} reps',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      context,
                      icon: Icons.repeat,
                      label: '${exercise.sets} sets',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      context,
                      icon: Icons.timer,
                      label: '${exercise.restBetweenSets}s rest',
                    ),
                  ],
                ),
                if (showControls)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onView != null)
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: onView,
                            color: Colors.blue,
                            tooltip: 'View',
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: onEdit,
                          color: Colors.orange,
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: onDelete,
                          color: Colors.red,
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
