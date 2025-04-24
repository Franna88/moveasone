import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final String? videoName;

  const FullScreenVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.videoName,
  }) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  List<Map<String, dynamic>> _videos = [];
  int _currentVideoIndex = 0;
  bool _isControlsVisible = true;
  bool _isLoading = true;
  bool _isPlaying = false;
  Timer? _hideControlsTimer;

  // Modern wellness color palette
  final Color primaryColor = const Color(0xFF025959); // Deep Teal
  final Color secondaryColor = const Color(0xFF01B3B3); // Bright Teal
  final Color accentColor = const Color(0xFF94FBAB); // Mint/Lime
  final Color textColorLight = const Color(0xFFF8FFFA);

  // Animation for controls
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Lock to portrait mode for better shorts experience
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // Fetch shorts and initialize
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('shorts')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> videos = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'videoUrl': data['videoUrl'] as String,
          'thumbnailUrl': data['thumbnailUrl'] as String,
          'videoName': data['videoName'] as String,
        };
      }).toList();

      setState(() {
        _videos = videos;

        // Find the index of the current video URL
        if (widget.videoUrl.isNotEmpty) {
          int foundIndex = videos
              .indexWhere((video) => video['videoUrl'] == widget.videoUrl);
          _currentVideoIndex = foundIndex != -1 ? foundIndex : 0;
        }

        _initializeVideoPlayer(_videos[_currentVideoIndex]['videoUrl']);
      });
    } catch (e) {
      print('Error fetching videos: $e');
      // Initialize with the passed videoUrl if fetch fails
      _initializeVideoPlayer(widget.videoUrl);
    }
  }

  void _initializeVideoPlayer(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
          _controller.play();
          _isPlaying = true;
        });
        _startHideControlsTimer();
      });

    _controller.addListener(() {
      setState(() {});
      if (_controller.value.isCompleted) {
        _playNextVideo();
      }
    });
  }

  void _disposeCurrentController() {
    _controller.removeListener(() {});
    _controller.dispose();
  }

  void _changeVideo(int index) {
    if (index >= 0 && index < _videos.length) {
      setState(() {
        _isLoading = true;
        _currentVideoIndex = index;
      });

      _disposeCurrentController();
      _initializeVideoPlayer(_videos[index]['videoUrl']);
    }
  }

  void _playNextVideo() {
    _changeVideo(_currentVideoIndex + 1);
  }

  void _playPreviousVideo() {
    _changeVideo(_currentVideoIndex - 1);
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
        // Keep controls visible when paused
        _cancelHideControlsTimer();
      } else {
        _controller.play();
        _isPlaying = true;
        _startHideControlsTimer();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;

      if (_isControlsVisible) {
        _animationController.forward();
        _startHideControlsTimer();
      } else {
        _animationController.reverse();
        _cancelHideControlsTimer();
      }
    });
  }

  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    if (_isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          _isControlsVisible = false;
          _animationController.reverse();
        });
      });
    }
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  String _formatDuration(Duration duration) {
    return duration.inHours > 0
        ? '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _disposeCurrentController();
    _animationController.dispose();

    // Restore system UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _videos.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            )
          : _buildPageView(),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _videos.length,
      controller: PageController(initialPage: _currentVideoIndex),
      onPageChanged: (index) {
        _changeVideo(index);
      },
      itemBuilder: (context, index) {
        return _buildVideoItem(index);
      },
    );
  }

  Widget _buildVideoItem(int index) {
    final Map<String, dynamic> videoData = _videos[index];
    final bool isCurrentVideo = index == _currentVideoIndex;

    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video player
            _isLoading && isCurrentVideo
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  )
                : isCurrentVideo
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Center(
                        child: Image.network(
                          videoData['thumbnailUrl'] ?? '',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(accentColor),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: primaryColor.withOpacity(0.2),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 64,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

            // Controls overlay
            if (isCurrentVideo)
              FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedOpacity(
                  opacity: _isControlsVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Stack(
                    children: [
                      // Top gradient
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite_border_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.share_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom gradient and content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video title
                              Text(
                                videoData['videoName'] ?? 'Wellness Video',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),

                              // Video progress indicator
                              Container(
                                height: 4,
                                child: isCurrentVideo
                                    ? LinearProgressIndicator(
                                        value: _controller.value.isInitialized
                                            ? _controller.value.position
                                                    .inMilliseconds /
                                                _controller.value.duration
                                                    .inMilliseconds
                                            : 0.0,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.3),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                accentColor),
                                      )
                                    : Container(),
                              ),
                              SizedBox(height: 20),

                              // Playback controls
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Previous video button
                                  IconButton(
                                    icon: Icon(
                                      Icons.skip_previous_rounded,
                                      color: _currentVideoIndex > 0
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.3),
                                      size: 28,
                                    ),
                                    onPressed: _currentVideoIndex > 0
                                        ? _playPreviousVideo
                                        : null,
                                  ),

                                  // Play/pause button with accent circle
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor.withOpacity(0.3),
                                      border: Border.all(
                                        color: accentColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: _togglePlayPause,
                                    ),
                                  ),

                                  // Next video button
                                  IconButton(
                                    icon: Icon(
                                      Icons.skip_next_rounded,
                                      color: _currentVideoIndex <
                                              _videos.length - 1
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.3),
                                      size: 28,
                                    ),
                                    onPressed:
                                        _currentVideoIndex < _videos.length - 1
                                            ? _playNextVideo
                                            : null,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              // Swipe indicator
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Swipe for next video',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
