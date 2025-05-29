import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class WorkoutExercise {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String audioUrl;
  final String equipment;
  final String difficulty;
  final String topic;
  final int sets;
  final int reps;
  final int restBetweenSets; // in seconds
  final int duration; // in seconds
  final bool isTimeBased; // if true, use duration instead of reps

  WorkoutExercise({
    String? id,
    required this.name,
    required this.description,
    this.imageUrl = '',
    this.videoUrl = '',
    this.audioUrl = '',
    required this.equipment,
    required this.difficulty,
    this.topic = 'Strength',
    required this.sets,
    required this.reps,
    required this.restBetweenSets,
    required this.duration,
    required this.isTimeBased,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'equipment': equipment,
      'difficulty': difficulty,
      'topic': topic,
      'sets': sets,
      'reps': reps,
      'restBetweenSets': restBetweenSets,
      'duration': duration,
      'isTimeBased': isTimeBased,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      equipment: json['equipment'],
      difficulty: json['difficulty'],
      topic: json['topic'] ?? 'Strength',
      sets: json['sets'],
      reps: json['reps'],
      restBetweenSets: json['restBetweenSets'],
      duration: json['duration'],
      isTimeBased: json['isTimeBased'],
    );
  }
}

class Workout {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> categories;
  final String difficulty;
  final List<String> bodyAreas;
  final List<String> equipment;
  final List<String> weekdays;
  final int estimatedDuration; // in minutes
  final List<WorkoutExercise> warmups;
  final List<WorkoutExercise> exercises;
  final List<WorkoutExercise> cooldowns;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout({
    String? id,
    required this.name,
    required this.description,
    this.imageUrl = '',
    required this.categories,
    required this.difficulty,
    required this.bodyAreas,
    required this.equipment,
    required this.weekdays,
    required this.estimatedDuration,
    List<WorkoutExercise>? warmups,
    List<WorkoutExercise>? exercises,
    List<WorkoutExercise>? cooldowns,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        warmups = warmups ?? [],
        exercises = exercises ?? [],
        cooldowns = cooldowns ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories,
      'difficulty': difficulty,
      'bodyAreas': bodyAreas,
      'equipment': equipment,
      'weekdays': weekdays,
      'estimatedDuration': estimatedDuration,
      'warmups': warmups.map((e) => e.toJson()).toList(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'cooldowns': cooldowns.map((e) => e.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? '',
      categories: List<String>.from(json['categories']),
      difficulty: json['difficulty'],
      bodyAreas: List<String>.from(json['bodyAreas']),
      equipment: List<String>.from(json['equipment']),
      weekdays: List<String>.from(json['weekdays']),
      estimatedDuration: json['estimatedDuration'],
      warmups: (json['warmups'] as List?)
              ?.map((e) => WorkoutExercise.fromJson(e))
              .toList() ??
          [],
      exercises: (json['exercises'] as List?)
              ?.map((e) => WorkoutExercise.fromJson(e))
              .toList() ??
          [],
      cooldowns: (json['cooldowns'] as List?)
              ?.map((e) => WorkoutExercise.fromJson(e))
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Workout copyWith({
    String? name,
    String? description,
    String? imageUrl,
    List<String>? categories,
    String? difficulty,
    List<String>? bodyAreas,
    List<String>? equipment,
    List<String>? weekdays,
    int? estimatedDuration,
    List<WorkoutExercise>? warmups,
    List<WorkoutExercise>? exercises,
    List<WorkoutExercise>? cooldowns,
  }) {
    return Workout(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      difficulty: difficulty ?? this.difficulty,
      bodyAreas: bodyAreas ?? this.bodyAreas,
      equipment: equipment ?? this.equipment,
      weekdays: weekdays ?? this.weekdays,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      warmups: warmups ?? this.warmups,
      exercises: exercises ?? this.exercises,
      cooldowns: cooldowns ?? this.cooldowns,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
