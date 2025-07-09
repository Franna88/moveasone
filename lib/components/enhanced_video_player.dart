import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../Services/enhanced_video_service.dart';
import '../Services/network_connectivity_service.dart';

class EnhancedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;
  final String? thumbnailUrl;
  final double? aspectRatio;
  final bool autoPlay;
  final bool showControls;
  final bool enableFullScreen;
  final VoidCallback? onError;
  final VoidCallback? onLoaded;
  final VoidCallback? onRetry;

  const EnhancedVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
    this.thumbnailUrl,
    this.aspectRatio,
    this.autoPlay = true,
    this.showControls = true,
    this.enableFullScreen = false,
    this.onError,
    this.onLoaded,
    this.onRetry,
  }) : super(key: key);

  @override
  State<EnhancedVideoPlayer> createState() => _EnhancedVideoPlayerState();
}

class _EnhancedVideoPlayerState extends State<EnhancedVideoPlayer> {
  final EnhancedVideoService _videoService = EnhancedVideoService();
  final NetworkConnectivityService _networkService =
      NetworkConnectivityService();

  VideoPlayerController? _controller;
  VideoLoadState _loadState = VideoLoadState.initial;
  String? _errorMessage;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadVideo() async {
    setState(() {
      _loadState = VideoLoadState.loading;
      _errorMessage = null;
    });

    final result = await _videoService.loadVideo(
      videoUrl: widget.videoUrl,
      timeout: const Duration(seconds: 30),
      maxRetries: 3,
      checkConnectivity: true,
    );

    if (mounted) {
      setState(() {
        _loadState = result.state;
        _errorMessage = result.errorMessage;

        if (result.controller != null) {
          _controller = result.controller;
          _setupVideoPlayerListener();

          if (widget.autoPlay) {
            _controller!.play();
            _isPlaying = true;
          }

          widget.onLoaded?.call();
        } else {
          widget.onError?.call();
        }
      });
    }
  }

  void _setupVideoPlayerListener() {
    if (_controller == null) return;

    _controller!.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller!.value.isPlaying;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      if (_isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  void _retry() {
    widget.onRetry?.call();
    _loadVideo();
  }

  Widget _buildErrorWidget() {
    IconData errorIcon;
    String errorTitle;
    Color errorColor;

    switch (_loadState) {
      case VideoLoadState.networkError:
        errorIcon = Icons.wifi_off;
        errorTitle = 'Network Error';
        errorColor = Colors.orange;
        break;
      case VideoLoadState.timeout:
        errorIcon = Icons.timer_off;
        errorTitle = 'Connection Timeout';
        errorColor = Colors.blue;
        break;
      default:
        errorIcon = Icons.error_outline;
        errorTitle = 'Video Error';
        errorColor = Colors.red;
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                errorIcon,
                color: errorColor,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                errorTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _videoService.getErrorMessage(_loadState, _errorMessage),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Show thumbnail if available
          if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.video_library_outlined,
                      color: Colors.white54,
                      size: 64,
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

  Widget _buildVideoPlayer() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.video_library_outlined,
            color: Colors.white54,
            size: 64,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.showControls
          ? () {
              setState(() {
                _showControls = !_showControls;
              });
            }
          : null,
      child: Stack(
        children: [
          // Video player
          Center(
            child: widget.aspectRatio != null
                ? AspectRatio(
                    aspectRatio: widget.aspectRatio!,
                    child: VideoPlayer(_controller!),
                  )
                : AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
          ),

          // Controls overlay
          if (widget.showControls && _showControls)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Play/Pause button
                    Center(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    // Top controls
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.videoTitle != null)
                            Expanded(
                              child: Text(
                                widget.videoTitle!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (widget.enableFullScreen)
                            IconButton(
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white),
                              onPressed: () {
                                // Handle fullscreen
                              },
                            ),
                        ],
                      ),
                    ),

                    // Bottom controls
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          // Progress bar
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.white,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_loadState) {
      case VideoLoadState.loading:
        return _buildLoadingWidget();
      case VideoLoadState.error:
      case VideoLoadState.networkError:
      case VideoLoadState.timeout:
        return _buildErrorWidget();
      case VideoLoadState.loaded:
        return _buildVideoPlayer();
      default:
        return _buildLoadingWidget();
    }
  }
}
