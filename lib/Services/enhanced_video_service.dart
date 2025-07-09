import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'network_connectivity_service.dart';

enum VideoLoadState {
  initial,
  loading,
  loaded,
  error,
  networkError,
  timeout,
}

class VideoLoadResult {
  final VideoLoadState state;
  final String? errorMessage;
  final VideoPlayerController? controller;

  VideoLoadResult({
    required this.state,
    this.errorMessage,
    this.controller,
  });
}

class EnhancedVideoService {
  static final EnhancedVideoService _instance =
      EnhancedVideoService._internal();
  factory EnhancedVideoService() => _instance;
  EnhancedVideoService._internal();

  final NetworkConnectivityService _networkService =
      NetworkConnectivityService();
  final Map<String, VideoPlayerController> _controllers = {};

  /// Load video with enhanced error handling
  Future<VideoLoadResult> loadVideo({
    required String videoUrl,
    Duration timeout = const Duration(seconds: 30),
    int maxRetries = 3,
    bool checkConnectivity = true,
  }) async {
    try {
      // Validate URL
      if (videoUrl.isEmpty || videoUrl == 'null') {
        debugPrint('EnhancedVideoService: Invalid URL provided');
        return VideoLoadResult(
          state: VideoLoadState.error,
          errorMessage: 'Invalid video URL provided',
        );
      }

      debugPrint('EnhancedVideoService: Starting video load for: $videoUrl');

      // Check network connectivity first (with fallback)
      if (checkConnectivity) {
        try {
          debugPrint('EnhancedVideoService: Checking network connectivity...');
          final isConnected = await _networkService.isConnected.timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint(
                  'EnhancedVideoService: Network connectivity check timed out, proceeding anyway');
              return true; // Fallback to attempting video load
            },
          );

          if (!isConnected) {
            debugPrint(
                'EnhancedVideoService: Network connectivity check failed');
            return VideoLoadResult(
              state: VideoLoadState.networkError,
              errorMessage:
                  'No internet connection. Please check your network settings.',
            );
          }
          debugPrint('EnhancedVideoService: Network connectivity check passed');
        } catch (e) {
          debugPrint(
              'EnhancedVideoService: Network connectivity check error: $e, proceeding anyway');
          // Don't fail here, just proceed with video loading
        }
      }

      // Try to load video with retries
      for (int attempt = 1; attempt <= maxRetries; attempt++) {
        debugPrint(
            'EnhancedVideoService: Loading video attempt $attempt of $maxRetries');
        debugPrint('EnhancedVideoService: URL: $videoUrl');

        try {
          // Check if URL is reachable (with fallback)
          if (checkConnectivity) {
            try {
              debugPrint(
                  'EnhancedVideoService: Checking if URL is reachable...');
              final isUrlReachable =
                  await _networkService.isUrlReachable(videoUrl).timeout(
                const Duration(seconds: 10),
                onTimeout: () {
                  debugPrint(
                      'EnhancedVideoService: URL reachability check timed out, proceeding anyway');
                  return true; // Fallback to attempting video load
                },
              );

              if (!isUrlReachable) {
                debugPrint(
                    'EnhancedVideoService: URL not reachable, but attempting anyway');
                // Don't throw exception, just log and proceed
              } else {
                debugPrint(
                    'EnhancedVideoService: URL reachability check passed');
              }
            } catch (e) {
              debugPrint(
                  'EnhancedVideoService: URL reachability check error: $e, proceeding anyway');
              // Don't fail here, just proceed with video loading
            }
          }

          // Create video controller
          VideoPlayerController controller;

          try {
            // Try new networkUrl constructor first
            controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
            debugPrint(
                'EnhancedVideoService: Created controller with networkUrl');
          } catch (e) {
            // Fallback to legacy network constructor
            controller = VideoPlayerController.network(videoUrl);
            debugPrint(
                'EnhancedVideoService: Created controller with legacy network');
          }

          // Initialize with timeout
          await controller.initialize().timeout(
            timeout,
            onTimeout: () {
              controller.dispose();
              throw TimeoutException('Video initialization timeout', timeout);
            },
          );

          debugPrint('EnhancedVideoService: Video loaded successfully');

          // Store controller for potential reuse
          _controllers[videoUrl] = controller;

          return VideoLoadResult(
            state: VideoLoadState.loaded,
            controller: controller,
          );
        } catch (e) {
          debugPrint('EnhancedVideoService: Attempt $attempt failed: $e');

          // Handle specific error types
          if (e is PlatformException) {
            debugPrint(
                'EnhancedVideoService: PlatformException - Code: ${e.code}, Message: ${e.message}');
            if (e.code == 'VideoError' ||
                e.message?.contains('network') == true) {
              if (attempt < maxRetries) {
                debugPrint(
                    'EnhancedVideoService: Retrying after network error...');
                await Future.delayed(Duration(seconds: attempt * 2));
                continue;
              }

              // Only return network error if we've exhausted retries
              return VideoLoadResult(
                state: VideoLoadState.networkError,
                errorMessage:
                    'Network connection issue. Please check your internet connection and try again.',
              );
            }
          }

          if (e is TimeoutException) {
            debugPrint(
                'EnhancedVideoService: TimeoutException after ${timeout.inSeconds} seconds');
            if (attempt < maxRetries) {
              debugPrint('EnhancedVideoService: Retrying after timeout...');
              await Future.delayed(Duration(seconds: attempt * 2));
              continue;
            }

            return VideoLoadResult(
              state: VideoLoadState.timeout,
              errorMessage: 'Video loading timeout. Please try again.',
            );
          }

          // For other errors, retry if we have attempts left
          if (attempt < maxRetries) {
            debugPrint('EnhancedVideoService: Retrying after error: $e');
            await Future.delayed(Duration(seconds: attempt * 2));
            continue;
          }

          // Final attempt failed
          debugPrint('EnhancedVideoService: All retry attempts failed');
          return VideoLoadResult(
            state: VideoLoadState.error,
            errorMessage: 'Failed to load video: ${e.toString()}',
          );
        }
      }

      // This shouldn't be reached, but just in case
      return VideoLoadResult(
        state: VideoLoadState.error,
        errorMessage: 'Failed to load video after $maxRetries attempts',
      );
    } catch (e) {
      debugPrint('EnhancedVideoService: Unexpected error: $e');
      return VideoLoadResult(
        state: VideoLoadState.error,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Get user-friendly error message
  String getErrorMessage(VideoLoadState state, String? originalMessage) {
    switch (state) {
      case VideoLoadState.networkError:
        return 'Network connection lost. Please check your internet connection and try again.';
      case VideoLoadState.timeout:
        return 'Video loading timeout. Please try again.';
      case VideoLoadState.error:
        if (originalMessage?.contains('PlatformException') == true) {
          return 'Video playback error. Please try again.';
        }
        return originalMessage ?? 'Failed to load video';
      default:
        return originalMessage ?? 'Unknown error';
    }
  }

  /// Get cached controller if available
  VideoPlayerController? getCachedController(String videoUrl) {
    return _controllers[videoUrl];
  }

  /// Dispose controller
  void disposeController(String videoUrl) {
    final controller = _controllers[videoUrl];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(videoUrl);
    }
  }

  /// Dispose all controllers
  void disposeAllControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  /// Check if video URL is valid
  bool isValidVideoUrl(String url) {
    if (url.isEmpty || url == 'null') return false;

    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Dispose service
  void dispose() {
    disposeAllControllers();
    _networkService.dispose();
  }
}
