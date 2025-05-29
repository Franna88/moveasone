class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String audioUrl;
  final String equipment;
  final String difficulty;
  final int sets;
  final int reps;
  final int restBetweenSets;
  final int duration;
  final bool isTimeBased;
  final int selectedMinutes;
  final int selectedSeconds;
  final String repetition;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.audioUrl,
    required this.equipment,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.restBetweenSets,
    required this.duration,
    required this.isTimeBased,
    required this.selectedMinutes,
    required this.selectedSeconds,
    required this.repetition,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    // Determine if this is the new format by checking for certain fields
    bool isNewFormat = json.containsKey('repetition') == false;

    return ExerciseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      equipment: json['equipment'] ?? 'No Equipment',
      difficulty: json['difficulty'] ?? 'Basic',
      sets: json['sets'] ?? 1,
      reps: json['reps'] ?? 10,
      restBetweenSets: json['restBetweenSets'] ?? 30,
      duration: json['duration'] ?? 30,
      isTimeBased: json['isTimeBased'] ?? false,
      // Handle the different ways rest time is stored in old vs new format
      selectedMinutes: isNewFormat ? 0 : json['selectedMinutes'] ?? 0,
      selectedSeconds: isNewFormat ? 30 : json['selectedSeconds'] ?? 30,
      // Handle repetition (old format stores it as a string, new as a number)
      repetition: isNewFormat
          ? (json['sets'] ?? 1).toString()
          : json['repetition']?.toString() ?? '1',
    );
  }

  Map<String, dynamic> toJson() {
    // Convert to the new format for consistency
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'equipment': equipment,
      'difficulty': difficulty,
      'sets': sets,
      'reps': reps,
      'restBetweenSets': restBetweenSets,
      'duration': duration,
      'isTimeBased': isTimeBased,
    };
  }
}

class WorkoutModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String bodyArea;
  final String difficulty;
  final List<String> equipment;
  final List<String> categories;
  final List<String> weekdays;
  final int duration;
  final List<ExerciseModel> warmups;
  final List<ExerciseModel> exercises;
  final List<ExerciseModel> cooldowns;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.bodyArea,
    required this.difficulty,
    required this.equipment,
    required this.categories,
    required this.weekdays,
    required this.duration,
    required this.warmups,
    required this.exercises,
    required this.cooldowns,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    // Check if this is a new format or old format workout
    bool isNewFormat =
        json.containsKey('exercises') && !json.containsKey('workouts');

    // Handle equipment either as a list or a string
    List<String> parseEquipment() {
      if (json['equipment'] == null) return [];
      if (json['equipment'] is List) {
        return (json['equipment'] as List).map((e) => e.toString()).toList();
      }
      if (json['equipment'] is String) {
        return [json['equipment'] as String];
      }
      return [];
    }

    // Handle categories
    List<String> parseCategories() {
      if (isNewFormat && json.containsKey('categories')) {
        return (json['categories'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
      }
      if (json.containsKey('selectedCategories')) {
        if (json['selectedCategories'] is List) {
          return (json['selectedCategories'] as List)
              .map((e) => e.toString())
              .toList();
        }
      }
      return [];
    }

    // Handle weekdays
    List<String> parseWeekdays() {
      if (isNewFormat && json.containsKey('weekdays')) {
        return (json['weekdays'] as List?)?.map((e) => e.toString()).toList() ??
            [];
      }
      if (json.containsKey('selectedWeekdays')) {
        if (json['selectedWeekdays'] is List) {
          return (json['selectedWeekdays'] as List)
              .map((e) => e.toString())
              .toList();
        }
      }
      return [];
    }

    // Parse exercises from either new or old format
    List<ExerciseModel> parseExercises(String key) {
      // Handle the case where the key doesn't exist
      if (!json.containsKey(key)) return [];

      // Handle the case where the value is null
      if (json[key] == null) return [];

      // Handle the case where the value is a list
      if (json[key] is List) {
        return (json[key] as List)
            .map((e) => ExerciseModel.fromJson(e))
            .toList();
      }

      return [];
    }

    // Get the right name field
    String getName() {
      return json['name'] as String? ?? '';
    }

    // Get the right description field
    String getDescription() {
      return json['description'] as String? ?? '';
    }

    // Get the right image URL field
    String getImageUrl() {
      return json['imageUrl'] as String? ??
          json['displayImage'] as String? ??
          '';
    }

    // Get the right body area field
    String getBodyArea() {
      if (isNewFormat &&
          json.containsKey('bodyAreas') &&
          json['bodyAreas'] is List &&
          (json['bodyAreas'] as List).isNotEmpty) {
        return (json['bodyAreas'] as List).first.toString();
      }
      return json['bodyArea'] as String? ?? '';
    }

    // Get the right duration field
    int getDuration() {
      if (isNewFormat && json.containsKey('estimatedDuration')) {
        return (json['estimatedDuration'] as num?)?.toInt() ?? 0;
      }
      if (json.containsKey('time')) {
        if (json['time'] is num) {
          return (json['time'] as num).toInt();
        } else {
          return int.tryParse(json['time'].toString()) ?? 0;
        }
      }
      return 0;
    }

    return WorkoutModel(
      id: json['id'] ?? '',
      name: getName(),
      description: getDescription(),
      imageUrl: getImageUrl(),
      bodyArea: getBodyArea(),
      difficulty: json['difficulty'] ?? 'Basic',
      equipment: parseEquipment(),
      categories: parseCategories(),
      weekdays: parseWeekdays(),
      duration: getDuration(),
      warmups:
          isNewFormat ? parseExercises('warmups') : parseExercises('warmUps'),
      exercises: isNewFormat
          ? parseExercises('exercises')
          : parseExercises('workouts'),
      cooldowns: isNewFormat
          ? parseExercises('cooldowns')
          : parseExercises('coolDowns'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'bodyAreas': [bodyArea], // Convert to new format's array
      'difficulty': difficulty,
      'equipment': equipment,
      'categories': categories,
      'weekdays': weekdays,
      'estimatedDuration': duration,
      'warmups': warmups.map((e) => e.toJson()).toList(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'cooldowns': cooldowns.map((e) => e.toJson()).toList(),
      // Include some legacy fields for backward compatibility
      'displayImage': imageUrl,
      'bodyArea': bodyArea,
      'time': duration,
    };
  }
}
