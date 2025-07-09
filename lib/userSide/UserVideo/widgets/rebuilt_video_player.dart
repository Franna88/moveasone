import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../services/rebuilt_video_service.dart';
import '../../../Services/enhanced_video_service.dart';

class RebuiltVideoPlayer extends StatefulWidget {
  final UserVideoModel video;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onBackPressed;

  const RebuiltVideoPlayer({
    Key? key,
    required this.video,
    this.autoPlay = true,
    this.showControls = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<RebuiltVideoPlayer> createState() => _RebuiltVideoPlayerState();
}

class _RebuiltVideoPlayerState extends State<RebuiltVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoController?.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Use EnhancedVideoService for robust video loading
      final videoService = EnhancedVideoService();
      final result = await videoService.loadVideo(
        videoUrl: widget.video.videoUrl,
        timeout: const Duration(seconds: 30),
        maxRetries: 3,
        checkConnectivity: true,
      );

      if (mounted) {
        if (result.state == VideoLoadState.loaded &&
            result.controller != null) {
          _videoController = result.controller!;

          // Create Chewie controller with custom settings
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: widget.autoPlay,
            looping: false,
            showControls: widget.showControls,
            allowFullScreen: true,
            allowMuting: true,
            allowPlaybackSpeedChanging: true,
            placeholder: _buildThumbnailPlaceholder(),
            errorBuilder: (context, errorMessage) =>
                _buildErrorWidget(errorMessage),
            materialProgressColors: ChewieProgressColors(
              playedColor: const Color(0xFF6699CC),
              handleColor: const Color(0xFF6699CC),
              backgroundColor: Colors.grey.shade300,
              bufferedColor: Colors.grey.shade100,
            ),
            customControls:
                widget.showControls ? _buildCustomControls() : Container(),
          );

          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = result.state == VideoLoadState.networkError
                ? 'Network error. Please check your connection and try again.'
                : 'Failed to load video: ${result.errorMessage}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load video: ${e.toString()}';
      });
      debugPrint('Video player initialization error: $e');
    }
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Thumbnail image
          if (widget.video.thumbnailUrl.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                widget.video.thumbnailUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.video_library_outlined,
                      size: 64,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),

          // Play button overlay
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomControls() {
    return Stack(
      children: [
        // Default Chewie controls
        const MaterialControls(),

        // Custom back button
        if (widget.onBackPressed != null)
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBackPressed,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Video Playback Error',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializePlayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6699CC),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video player area
            Expanded(
              child: Container(
                width: double.infinity,
                child: _buildPlayerContent(),
              ),
            ),

            // Video info section
            _buildVideoInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerContent() {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_hasError) {
      return _buildErrorWidget(_errorMessage);
    }

    if (_chewieController == null) {
      return _buildErrorWidget('Video controller not initialized');
    }

    return Chewie(controller: _chewieController!);
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Show thumbnail while loading
          if (widget.video.thumbnailUrl.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                widget.video.thumbnailUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.video_library_outlined,
                      size: 64,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),

          // Loading indicator
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6699CC)),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading video...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.video.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 8),

          // Category and duration row
          Row(
            children: [
              _buildInfoChip(
                _getCategoryEmoji(widget.video.category),
                _getCategoryDisplayName(widget.video.category),
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                '⏱️',
                _formatDuration(widget.video.duration),
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                '📱',
                widget.video.resolution,
              ),
            ],
          ),

          // Description (if available)
          if (widget.video.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.video.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                height: 1.5,
              ),
            ),
          ],

          // Upload date
          const SizedBox(height: 12),
          Text(
            'Uploaded ${_formatDate(widget.video.uploadDate)}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF74B9FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6699CC).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6699CC).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6699CC),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'workout':
        return '💪';
      case 'progress':
        return '📈';
      case 'tutorial':
        return '🎓';
      case 'motivation':
        return '🔥';
      default:
        return '📱';
    }
  }

  String _getCategoryDisplayName(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }
  }
}
