import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/video_models.dart';

// Upload progress callback
typedef ProgressCallback = void Function(double progress);

class VideoUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Uploads a user video with compression, thumbnail generation, and metadata
  Future<UserVideo> uploadUserVideo({
    required File videoFile,
    required String videoName,
    required VideoType videoType,
    required WorkoutType workoutType,
    String description = '',
    List<String> tags = const [],
    PrivacyLevel privacy = PrivacyLevel.private,
    ProgressCallback? onProgress,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final videoId = const Uuid().v4();

      // Step 1: Compress video if needed
      onProgress?.call(0.1);
      final compressedVideo = await _compressVideo(videoFile, onProgress);

      // Step 2: Generate thumbnail
      onProgress?.call(0.3);
      final thumbnailFile = await _generateThumbnail(compressedVideo, videoId);

      // Step 3: Get video duration
      final duration = await _getVideoDuration(compressedVideo);

      // Step 4: Upload video to Firebase Storage
      onProgress?.call(0.4);
      final videoUrl = await _uploadVideoFile(
        compressedVideo,
        user.uid,
        videoId,
        videoType,
        (progress) => onProgress?.call(0.4 + (progress * 0.4)),
      );

      // Step 5: Upload thumbnail
      onProgress?.call(0.8);
      final thumbnailUrl = await _uploadThumbnailFile(
        thumbnailFile,
        user.uid,
        videoId,
        (progress) => onProgress?.call(0.8 + (progress * 0.1)),
      );

      // Step 6: Create video object
      final userVideo = UserVideo(
        videoId: videoId,
        videoName: videoName,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        uploadDate: DateTime.now(),
        videoType: videoType,
        workoutType: workoutType,
        duration: duration,
        tags: tags,
        description: description,
        privacy: privacy,
        metrics: VideoMetrics(lastViewed: DateTime.now()),
      );

      // Step 7: Save to Firestore
      onProgress?.call(0.9);
      await _saveVideoMetadata(user.uid, userVideo);

      // Step 8: Cleanup temporary files
      await _cleanupTempFiles([compressedVideo, thumbnailFile]);

      onProgress?.call(1.0);
      return userVideo;
    } catch (e) {
      debugPrint('Error uploading video: $e');
      rethrow;
    }
  }

  /// Compress video to reduce file size with better progress tracking
  Future<File> _compressVideo(
      File videoFile, ProgressCallback? onProgress) async {
    try {
      // Check file size first
      final fileSize = await videoFile.length();
      const maxSizeBytes = 100 * 1024 * 1024; // 100MB limit

      debugPrint('Original video size: ${fileSize / (1024 * 1024)} MB');

      if (fileSize > maxSizeBytes) {
        debugPrint('Compressing video...');

        try {
          final compressedInfo = await VideoCompress.compressVideo(
            videoFile.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: true,
          );

          if (compressedInfo?.file != null) {
            final compressedSize = await compressedInfo!.file!.length();
            debugPrint(
                'Compressed video size: ${compressedSize / (1024 * 1024)} MB');
            debugPrint(
                'Compression ratio: ${((fileSize - compressedSize) / fileSize * 100).toStringAsFixed(1)}%');
            return compressedInfo.file!;
          }
        } catch (e) {
          debugPrint('Video compression failed: $e');
        }
      }

      return videoFile;
    } catch (e) {
      debugPrint('Video compression failed: $e');
      return videoFile; // Return original if compression fails
    }
  }

  /// Generate thumbnail from video with better error handling
  Future<File> _generateThumbnail(File videoFile, String videoId) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = '${tempDir.path}/$videoId.jpg';

      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 80,
        timeMs: 1000, // Get thumbnail from 1 second into the video
      );

      if (thumbnailFile == null) {
        throw Exception('Failed to generate thumbnail');
      }

      debugPrint('Thumbnail generated: $thumbnailFile');
      return File(thumbnailFile);
    } catch (e) {
      debugPrint('Thumbnail generation error: $e');
      rethrow;
    }
  }

  /// Get video duration using VideoCompress
  Future<int> _getVideoDuration(File videoFile) async {
    try {
      final mediaInfo = await VideoCompress.getMediaInfo(videoFile.path);
      final duration = mediaInfo.duration ?? 0;
      debugPrint('Video duration: ${duration ~/ 1000} seconds');
      return duration ~/ 1000; // Convert milliseconds to seconds
    } catch (e) {
      debugPrint('Failed to get video duration: $e');
      return 0;
    }
  }

  /// Upload video file to Firebase Storage with organized structure
  Future<String> _uploadVideoFile(
    File videoFile,
    String userId,
    String videoId,
    VideoType videoType,
    ProgressCallback? onProgress,
  ) async {
    // Organize videos by type
    final videoTypeFolder = videoType.name;
    final ref = _storage
        .ref()
        .child('userVideos/$userId/$videoTypeFolder/$videoId.mp4');

    final uploadTask = ref.putFile(
      videoFile,
      SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {
          'userId': userId,
          'videoId': videoId,
          'videoType': videoType.name,
          'uploadTime': DateTime.now().toIso8601String(),
        },
      ),
    );

    // Listen to upload progress
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
      debugPrint(
          'Video upload progress: ${(progress * 100).toStringAsFixed(1)}%');
    });

    await uploadTask;
    final downloadUrl = await ref.getDownloadURL();
    debugPrint('Video uploaded successfully: $downloadUrl');
    return downloadUrl;
  }

  /// Upload thumbnail file to Firebase Storage
  Future<String> _uploadThumbnailFile(
    File thumbnailFile,
    String userId,
    String videoId,
    ProgressCallback? onProgress,
  ) async {
    final ref = _storage.ref().child('userThumbnails/$userId/$videoId.jpg');

    final uploadTask = ref.putFile(
      thumbnailFile,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': userId,
          'videoId': videoId,
        },
      ),
    );

    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
      debugPrint(
          'Thumbnail upload progress: ${(progress * 100).toStringAsFixed(1)}%');
    });

    await uploadTask;
    final downloadUrl = await ref.getDownloadURL();
    debugPrint('Thumbnail uploaded successfully: $downloadUrl');
    return downloadUrl;
  }

  /// Save video metadata to Firestore with better error handling
  Future<void> _saveVideoMetadata(String userId, UserVideo video) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'userVideos': FieldValue.arrayUnion([video.toJson()]),
        'videoCount': FieldValue.increment(1),
        'lastVideoUpload': FieldValue.serverTimestamp(),
        'totalVideoTime': FieldValue.increment(video.duration),
      });
      debugPrint('Video metadata saved successfully');
    } catch (e) {
      debugPrint('Error saving video metadata: $e');
      rethrow;
    }
  }

  /// Clean up temporary files
  Future<void> _cleanupTempFiles(List<File> files) async {
    for (final file in files) {
      try {
        if (await file.exists()) {
          await file.delete();
          debugPrint('Cleaned up temp file: ${file.path}');
        }
      } catch (e) {
        debugPrint('Failed to delete temp file: ${file.path}');
      }
    }
  }

  /// Delete a user video with complete cleanup
  Future<void> deleteUserVideo(String videoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user document to find the video details
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userVideos =
          List<Map<String, dynamic>>.from(userDoc.data()?['userVideos'] ?? []);

      // Find the video to delete
      final videoToDelete = userVideos.firstWhere(
        (video) => video['videoId'] == videoId,
        orElse: () => throw Exception('Video not found'),
      );

      final videoType = VideoType.values.byName(videoToDelete['videoType']);
      final duration = videoToDelete['duration'] ?? 0;

      // Delete from Storage
      try {
        await _storage
            .ref()
            .child('userVideos/${user.uid}/${videoType.name}/$videoId.mp4')
            .delete();
        debugPrint('Video file deleted from storage');
      } catch (e) {
        debugPrint('Error deleting video file: $e');
      }

      try {
        await _storage
            .ref()
            .child('userThumbnails/${user.uid}/$videoId.jpg')
            .delete();
        debugPrint('Thumbnail deleted from storage');
      } catch (e) {
        debugPrint('Error deleting thumbnail: $e');
      }

      // Remove from Firestore
      userVideos.removeWhere((video) => video['videoId'] == videoId);

      await _firestore.collection('users').doc(user.uid).update({
        'userVideos': userVideos,
        'videoCount': FieldValue.increment(-1),
        'totalVideoTime': FieldValue.increment(-duration),
      });

      debugPrint('Video deleted successfully');
    } catch (e) {
      debugPrint('Error deleting video: $e');
      rethrow;
    }
  }

  /// Get user video statistics
  Future<Map<String, dynamic>> getUserVideoStats(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data() ?? {};

      return {
        'totalVideos': data['videoCount'] ?? 0,
        'totalDuration': data['totalVideoTime'] ?? 0,
        'lastUpload': data['lastVideoUpload'],
      };
    } catch (e) {
      debugPrint('Error getting video stats: $e');
      return {
        'totalVideos': 0,
        'totalDuration': 0,
        'lastUpload': null,
      };
    }
  }
}
