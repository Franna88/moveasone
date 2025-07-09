import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

// Progress callback for upload tracking
typedef UploadProgressCallback = void Function(double progress, String status);

class RebuiltVideoService {
  static final RebuiltVideoService _instance = RebuiltVideoService._internal();
  factory RebuiltVideoService() => _instance;
  RebuiltVideoService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // Video constraints
  static const int maxFileSizeMB = 100;
  static const int maxDurationSeconds = 3600; // 1 hour
  static const List<String> supportedFormats = ['.mp4', '.mov', '.avi'];

  /// Upload a video with complete processing pipeline
  Future<UserVideoModel> uploadVideo({
    required BuildContext context,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      // Step 1: Pick video file
      onProgress?.call(0.05, 'Selecting video...');
      final pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: maxDurationSeconds),
      );

      if (pickedFile == null) {
        throw Exception('No video selected');
      }

      final videoFile = File(pickedFile.path);

      // Step 2: Validate video
      onProgress?.call(0.1, 'Validating video...');
      await _validateVideo(videoFile);

      // Step 3: Get video metadata
      onProgress?.call(0.15, 'Extracting metadata...');
      final metadata = await _extractVideoMetadata(videoFile);

      // Step 4: Show upload dialog for additional info
      onProgress?.call(0.2, 'Getting video details...');
      final videoDetails = await _showUploadDialog(context, metadata);
      if (videoDetails == null) {
        throw Exception('Upload cancelled');
      }

      // Step 5: Compress video if needed
      onProgress?.call(0.3, 'Optimizing video...');
      final processedVideo = await _processVideo(videoFile, onProgress);

      // Step 6: Generate thumbnail
      onProgress?.call(0.5, 'Creating thumbnail...');
      final thumbnailFile = await _generateThumbnail(processedVideo);

      // Step 7: Upload files to Firebase
      onProgress?.call(0.6, 'Uploading video...');
      final videoUrl =
          await _uploadVideoFile(processedVideo, videoDetails, onProgress);

      onProgress?.call(0.8, 'Uploading thumbnail...');
      final thumbnailUrl =
          await _uploadThumbnailFile(thumbnailFile, videoDetails['videoId']);

      // Step 8: Create video model
      onProgress?.call(0.9, 'Saving metadata...');
      final userVideo = UserVideoModel(
        videoId: videoDetails['videoId'],
        title: videoDetails['title'],
        description: videoDetails['description'],
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        duration: metadata['duration'],
        fileSize: metadata['fileSize'],
        resolution: metadata['resolution'],
        category: videoDetails['category'],
        tags: videoDetails['tags'],
        uploadDate: DateTime.now(),
        isPublic: videoDetails['isPublic'] ?? false,
      );

      // Step 9: Save to Firestore
      await _saveVideoToFirestore(userVideo);

      // Step 10: Cleanup
      await _cleanupTempFiles([processedVideo, thumbnailFile]);

      onProgress?.call(1.0, 'Upload complete!');
      return userVideo;
    } catch (e) {
      debugPrint('Video upload error: $e');
      rethrow;
    }
  }

  /// Validate video file
  Future<void> _validateVideo(File videoFile) async {
    // Check file exists
    if (!await videoFile.exists()) {
      throw Exception('Video file not found');
    }

    // Check file size
    final fileSize = await videoFile.length();
    final maxSize = maxFileSizeMB * 1024 * 1024;
    if (fileSize > maxSize) {
      throw Exception('Video too large. Maximum size: ${maxFileSizeMB}MB');
    }

    // Check file extension
    final extension = videoFile.path.toLowerCase().split('.').last;
    if (!supportedFormats.any((format) => format.contains(extension))) {
      throw Exception(
          'Unsupported format. Supported: ${supportedFormats.join(', ')}');
    }
  }

  /// Extract video metadata
  Future<Map<String, dynamic>> _extractVideoMetadata(File videoFile) async {
    try {
      final mediaInfo = await VideoCompress.getMediaInfo(videoFile.path);
      final fileSize = await videoFile.length();

      return {
        'duration': (mediaInfo.duration ?? 0) ~/ 1000, // Convert to seconds
        'fileSize': fileSize,
        'resolution': '${mediaInfo.width ?? 0}x${mediaInfo.height ?? 0}',
        'path': videoFile.path,
      };
    } catch (e) {
      debugPrint('Error extracting metadata: $e');
      return {
        'duration': 0,
        'fileSize': await videoFile.length(),
        'resolution': 'Unknown',
        'path': videoFile.path,
      };
    }
  }

  /// Show upload dialog to collect video details
  Future<Map<String, dynamic>?> _showUploadDialog(
    BuildContext context,
    Map<String, dynamic> metadata,
  ) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'workout';
    List<String> tags = [];
    bool isPublic = false;

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Upload Video Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Video preview info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                          'Duration: ${_formatDuration(metadata['duration'])}'),
                      Text('Size: ${_formatFileSize(metadata['fileSize'])}'),
                      Text('Resolution: ${metadata['resolution']}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title field
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Video Title *',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                ),
                const SizedBox(height: 16),

                // Description field
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                const SizedBox(height: 16),

                // Category selector
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'workout', child: Text('💪 Workout')),
                    DropdownMenuItem(
                        value: 'progress', child: Text('📈 Progress')),
                    DropdownMenuItem(
                        value: 'tutorial', child: Text('🎓 Tutorial')),
                    DropdownMenuItem(
                        value: 'motivation', child: Text('🔥 Motivation')),
                    DropdownMenuItem(value: 'other', child: Text('📱 Other')),
                  ],
                  onChanged: (value) =>
                      setState(() => selectedCategory = value!),
                ),
                const SizedBox(height: 16),

                // Privacy toggle
                SwitchListTile(
                  title: const Text('Make Public'),
                  subtitle: const Text('Allow others to see this video'),
                  value: isPublic,
                  onChanged: (value) => setState(() => isPublic = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: titleController.text.trim().isEmpty
                  ? null
                  : () {
                      Navigator.of(context).pop({
                        'videoId': const Uuid().v4(),
                        'title': titleController.text.trim(),
                        'description': descriptionController.text.trim(),
                        'category': selectedCategory,
                        'tags': tags,
                        'isPublic': isPublic,
                      });
                    },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  /// Process video (compress if needed)
  Future<File> _processVideo(
    File originalVideo,
    UploadProgressCallback? onProgress,
  ) async {
    try {
      final fileSize = await originalVideo.length();
      const compressionThreshold = 50 * 1024 * 1024; // 50MB

      if (fileSize <= compressionThreshold) {
        debugPrint('Video size acceptable, skipping compression');
        return originalVideo;
      }

      debugPrint('Compressing video...');
      onProgress?.call(0.35, 'Compressing video...');

      final compressedInfo = await VideoCompress.compressVideo(
        originalVideo.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedInfo?.file != null) {
        final compressedSize = await compressedInfo!.file!.length();
        final compressionRatio = ((fileSize - compressedSize) / fileSize * 100);
        debugPrint(
            'Compression successful: ${compressionRatio.toStringAsFixed(1)}% reduction');
        return compressedInfo.file!;
      }

      debugPrint('Compression failed, using original');
      return originalVideo;
    } catch (e) {
      debugPrint('Compression error: $e, using original video');
      return originalVideo;
    }
  }

  /// Generate video thumbnail
  Future<File> _generateThumbnail(File videoFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = '${tempDir.path}/${const Uuid().v4()}.jpg';

      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 400,
        quality: 85,
        timeMs: 2000, // Get thumbnail from 2 seconds
      );

      if (thumbnailFile == null) {
        throw Exception('Failed to generate thumbnail');
      }

      return File(thumbnailFile);
    } catch (e) {
      debugPrint('Thumbnail generation error: $e');
      rethrow;
    }
  }

  /// Upload video file to Firebase Storage
  Future<String> _uploadVideoFile(
    File videoFile,
    Map<String, dynamic> details,
    UploadProgressCallback? onProgress,
  ) async {
    final user = _auth.currentUser!;
    final path =
        'userVideos/${user.uid}/${details['category']}/${details['videoId']}.mp4';
    final ref = _storage.ref().child(path);

    final uploadTask = ref.putFile(
      videoFile,
      SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {
          'userId': user.uid,
          'videoId': details['videoId'],
          'category': details['category'],
          'title': details['title'],
        },
      ),
    );

    // Track upload progress
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(0.6 + (progress * 0.15), 'Uploading video...');
    });

    await uploadTask;
    return await ref.getDownloadURL();
  }

  /// Upload thumbnail file to Firebase Storage
  Future<String> _uploadThumbnailFile(
      File thumbnailFile, String videoId) async {
    final user = _auth.currentUser!;
    final path = 'userThumbnails/${user.uid}/$videoId.jpg';
    final ref = _storage.ref().child(path);

    await ref.putFile(
      thumbnailFile,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': user.uid, 'videoId': videoId},
      ),
    );

    return await ref.getDownloadURL();
  }

  /// Save video metadata to Firestore
  Future<void> _saveVideoToFirestore(UserVideoModel video) async {
    final user = _auth.currentUser!;

    await _firestore.collection('users').doc(user.uid).update({
      'userVideos': FieldValue.arrayUnion([video.toJson()]),
      'videoStats.totalVideos': FieldValue.increment(1),
      'videoStats.totalDuration': FieldValue.increment(video.duration),
      'videoStats.lastUpload': FieldValue.serverTimestamp(),
    });
  }

  /// Get user videos from Firestore
  Future<List<UserVideoModel>> getUserVideos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data() ?? {};
      final videosJson =
          List<Map<String, dynamic>>.from(data['userVideos'] ?? []);

      return videosJson.map((json) => UserVideoModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching user videos: $e');
      return [];
    }
  }

  /// Delete video completely
  Future<void> deleteVideo(String videoId) async {
    try {
      final user = _auth.currentUser!;

      // Get current videos
      final videos = await getUserVideos();
      final videoToDelete = videos.firstWhere((v) => v.videoId == videoId);

      // Delete from Storage
      try {
        await _storage
            .ref()
            .child(
                'userVideos/${user.uid}/${videoToDelete.category}/$videoId.mp4')
            .delete();
        await _storage
            .ref()
            .child('userThumbnails/${user.uid}/$videoId.jpg')
            .delete();
      } catch (e) {
        debugPrint('Storage deletion error: $e');
      }

      // Remove from Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'userVideos': FieldValue.arrayRemove([videoToDelete.toJson()]),
        'videoStats.totalVideos': FieldValue.increment(-1),
        'videoStats.totalDuration':
            FieldValue.increment(-videoToDelete.duration),
      });
    } catch (e) {
      debugPrint('Error deleting video: $e');
      rethrow;
    }
  }

  /// Cleanup temporary files
  Future<void> _cleanupTempFiles(List<File> files) async {
    for (final file in files) {
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Cleanup error: $e');
      }
    }
  }

  /// Utility: Format duration
  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  /// Utility: Format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// User Video Model
class UserVideoModel {
  final String videoId;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int duration;
  final int fileSize;
  final String resolution;
  final String category;
  final List<String> tags;
  final DateTime uploadDate;
  final bool isPublic;

  UserVideoModel({
    required this.videoId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.fileSize,
    required this.resolution,
    required this.category,
    required this.tags,
    required this.uploadDate,
    required this.isPublic,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'fileSize': fileSize,
      'resolution': resolution,
      'category': category,
      'tags': tags,
      'uploadDate': uploadDate.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  factory UserVideoModel.fromJson(Map<String, dynamic> json) {
    return UserVideoModel(
      videoId: json['videoId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      duration: json['duration'] ?? 0,
      fileSize: json['fileSize'] ?? 0,
      resolution: json['resolution'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      uploadDate: DateTime.tryParse(json['uploadDate'] ?? '') ?? DateTime.now(),
      isPublic: json['isPublic'] ?? false,
    );
  }
}
