import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/enhanced_workout_viewer/models/workout_model.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final int index;
  final VoidCallback onTap;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _buildExerciseHeader(context),
              _buildExerciseDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseHeader(BuildContext context) {
    final bool hasValidImage = exercise.imageUrl.isNotEmpty &&
        (exercise.imageUrl.startsWith('http://') ||
            exercise.imageUrl.startsWith('https://'));

    return Stack(
      children: [
        // Image with gradient
        SizedBox(
          height: 140,
          width: double.infinity,
          child: hasValidImage
              ? Image.network(
                  exercise.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading exercise image: $error');
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.fitness_center,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
        ),
        // Dark gradient overlay
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
        // Exercise number indicator
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: UiColors().brown,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        // Exercise type indicator
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              exercise.difficulty,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        // Exercise name
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: Text(
            exercise.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.description,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildExerciseMetric(
                context,
                Icons.repeat,
                exercise.isTimeBased
                    ? '${exercise.duration} sec'
                    : '${exercise.reps} reps',
                exercise.isTimeBased ? 'Duration' : 'Reps',
              ),
              _buildExerciseMetric(
                context,
                Icons.fitness_center,
                '${exercise.sets} sets',
                'Sets',
              ),
              _buildExerciseMetric(
                context,
                Icons.timelapse,
                '${exercise.restBetweenSets} sec',
                'Rest',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.red,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                exercise.videoUrl.isNotEmpty ? 'Video available' : 'No video',
                style: TextStyle(
                  color:
                      exercise.videoUrl.isNotEmpty ? Colors.red : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.headphones,
                color: Colors.blue,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                exercise.audioUrl.isNotEmpty ? 'Audio guide' : 'No audio',
                style: TextStyle(
                  color:
                      exercise.audioUrl.isNotEmpty ? Colors.blue : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseMetric(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: UiColors().brown),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
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
    );
  }
}
