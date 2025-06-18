import 'package:flutter/material.dart';

class WorkoutProgressIndicator extends StatelessWidget {
  final String currentPhase;
  final int currentExerciseIndex;
  final int totalExercisesInPhase;
  final int totalWarmups;
  final int totalWorkouts;
  final int totalCooldowns;

  const WorkoutProgressIndicator({
    super.key,
    required this.currentPhase,
    required this.currentExerciseIndex,
    required this.totalExercisesInPhase,
    required this.totalWarmups,
    required this.totalWorkouts,
    required this.totalCooldowns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Warm-up phase indicator
          _buildPhaseIndicator(
            phase: 'Warm-up',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            isActive: currentPhase == 'warmUp',
            isCompleted: _isPhaseCompleted('warmUp'),
            hasExercises: totalWarmups > 0,
          ),

          if (totalWarmups > 0 && (totalWorkouts > 0 || totalCooldowns > 0))
            _buildConnector(isActive: _isPhaseCompleted('warmUp')),

          // Main workout phase indicator
          if (totalWorkouts > 0)
            _buildPhaseIndicator(
              phase: 'Workout',
              icon: Icons.fitness_center,
              color: Colors.red,
              isActive: currentPhase == 'workouts',
              isCompleted: _isPhaseCompleted('workouts'),
              hasExercises: totalWorkouts > 0,
            ),

          if (totalWorkouts > 0 && totalCooldowns > 0)
            _buildConnector(isActive: _isPhaseCompleted('workouts')),

          // Cool-down phase indicator
          if (totalCooldowns > 0)
            _buildPhaseIndicator(
              phase: 'Cool-down',
              icon: Icons.spa,
              color: Colors.blue,
              isActive: currentPhase == 'coolDowns',
              isCompleted: _isPhaseCompleted('coolDowns'),
              hasExercises: totalCooldowns > 0,
            ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator({
    required String phase,
    required IconData icon,
    required Color color,
    required bool isActive,
    required bool isCompleted,
    required bool hasExercises,
  }) {
    if (!hasExercises) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : isActive
                    ? color
                    : color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          phase,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive)
          Text(
            '${currentExerciseIndex + 1}/$totalExercisesInPhase',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
      ],
    );
  }

  Widget _buildConnector({required bool isActive}) {
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  bool _isPhaseCompleted(String phase) {
    switch (phase) {
      case 'warmUp':
        if (currentPhase == 'workouts' || currentPhase == 'coolDowns') {
          return totalWarmups > 0;
        }
        return false;
      case 'workouts':
        if (currentPhase == 'coolDowns') {
          return totalWorkouts > 0;
        }
        return false;
      case 'coolDowns':
        return false; // Never completed until workout is done
      default:
        return false;
    }
  }
}

class WorkoutPhaseProgress extends StatelessWidget {
  final String currentPhase;
  final int currentExerciseIndex;
  final int totalExercisesInPhase;

  const WorkoutPhaseProgress({
    super.key,
    required this.currentPhase,
    required this.currentExerciseIndex,
    required this.totalExercisesInPhase,
  });

  @override
  Widget build(BuildContext context) {
    String phaseTitle = _getPhaseTitle(currentPhase);
    Color phaseColor = _getPhaseColor(currentPhase);
    double progress = totalExercisesInPhase > 0
        ? (currentExerciseIndex + 1) / totalExercisesInPhase
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getPhaseIcon(currentPhase),
                color: phaseColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                phaseTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: phaseColor,
                ),
              ),
              const Spacer(),
              Text(
                '${currentExerciseIndex + 1} of $totalExercisesInPhase',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: phaseColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  String _getPhaseTitle(String phase) {
    switch (phase.toLowerCase()) {
      case 'warmup':
        return 'Warm Up';
      case 'workouts':
        return 'Main Workout';
      case 'cooldowns':
        return 'Cool down';
      default:
        return phase;
    }
  }

  Color _getPhaseColor(String phase) {
    switch (phase.toLowerCase()) {
      case 'warmup':
        return Colors.orange;
      case 'workouts':
        return Colors.red;
      case 'cooldowns':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  IconData _getPhaseIcon(String phase) {
    switch (phase.toLowerCase()) {
      case 'warmup':
        return Icons.local_fire_department;
      case 'workouts':
        return Icons.fitness_center;
      case 'cooldowns':
        return Icons.spa;
      default:
        return Icons.directions_run;
    }
  }
}
