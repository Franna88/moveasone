class UserVideo {
  final String videoId;
  final String videoName;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime uploadDate;
  final VideoType videoType;
  final WorkoutType workoutType;
  final int duration; // in seconds
  final List<String> tags;
  final String description;
  final PrivacyLevel privacy;
  final VideoMetrics? metrics;

  UserVideo({
    required this.videoId,
    required this.videoName,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.uploadDate,
    required this.videoType,
    required this.workoutType,
    required this.duration,
    this.tags = const [],
    this.description = '',
    this.privacy = PrivacyLevel.private,
    this.metrics,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'videoName': videoName,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'uploadDate': uploadDate.toIso8601String(),
      'videoType': videoType.name,
      'workoutType': workoutType.name,
      'duration': duration,
      'tags': tags,
      'description': description,
      'privacy': privacy.name,
      'metrics': metrics?.toJson(),
    };
  }

  factory UserVideo.fromJson(Map<String, dynamic> json) {
    return UserVideo(
      videoId: json['videoId'],
      videoName: json['videoName'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      uploadDate: DateTime.parse(json['uploadDate']),
      videoType: VideoType.values.byName(json['videoType']),
      workoutType: WorkoutType.values.byName(json['workoutType']),
      duration: json['duration'],
      tags: List<String>.from(json['tags'] ?? []),
      description: json['description'] ?? '',
      privacy: PrivacyLevel.values.byName(json['privacy'] ?? 'private'),
      metrics: json['metrics'] != null
          ? VideoMetrics.fromJson(json['metrics'])
          : null,
    );
  }
}

enum VideoType {
  workout, // Full workout sessions
  progress, // Progress tracking videos
  formCheck, // Form check videos
  achievement, // Achievement/milestone videos
  tutorial, // Personal technique tutorials
}

enum WorkoutType {
  cardio,
  strength,
  yoga,
  pilates,
  hiit,
  stretching,
  dance,
  sports,
  rehabilitation,
  other,
}

enum PrivacyLevel {
  private, // Only user can see
  shared, // Can be shared with trainer/friends
  public, // Public within app community
}

class VideoMetrics {
  final int views;
  final int likes;
  final double rating;
  final DateTime lastViewed;

  VideoMetrics({
    this.views = 0,
    this.likes = 0,
    this.rating = 0.0,
    required this.lastViewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'views': views,
      'likes': likes,
      'rating': rating,
      'lastViewed': lastViewed.toIso8601String(),
    };
  }

  factory VideoMetrics.fromJson(Map<String, dynamic> json) {
    return VideoMetrics(
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      lastViewed: DateTime.parse(json['lastViewed']),
    );
  }
}
