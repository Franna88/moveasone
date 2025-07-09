import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../../../Services/enhanced_video_service.dart';

class EnhancedVideoScreen extends StatefulWidget {
  final Function changePageIndex;
  final String videoUrl;
  final String workoutType;
  final String title;
  final int repsCounter;
  final String reps;
  final String description;
  final bool isTimeBased;
  final int duration;

  const EnhancedVideoScreen({
    Key? key,
    required this.changePageIndex,
    required this.videoUrl,
    required this.workoutType,
    required this.title,
    required this.repsCounter,
    required this.reps,
    required this.description,
    this.isTimeBased = false,
    this.duration = 30,
  }) : super(key: key);

  @override
  State<EnhancedVideoScreen> createState() => _EnhancedVideoScreenState();
}

class _EnhancedVideoScreenState extends State<EnhancedVideoScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isBuffering = true;
  bool _showControls = true;
  double _playbackSpeed = 1.0;
  Timer? _controlsTimer;
  Timer? _exerciseTimer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _remainingSeconds = 0;
  bool _timerActive = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _initializeVideo();

    // Setup timer for time-based exercises
    if (widget.isTimeBased) {
      _remainingSeconds = widget.duration;
    }
  }

  Future<void> _initializeVideo() async {
    try {
      setState(() {
        _isBuffering = true;
      });

      // Use EnhancedVideoService for robust video loading
      final videoService = EnhancedVideoService();
      final result = await videoService.loadVideo(
        videoUrl: widget.videoUrl,
        timeout: const Duration(seconds: 30),
        maxRetries: 3,
        checkConnectivity: true,
      );

      if (mounted) {
        if (result.state == VideoLoadState.loaded &&
            result.controller != null) {
          _controller = result.controller!;

          // Add listener for video state changes
          _controller.addListener(() {
            if (mounted) {
              final isPlaying = _controller.value.isPlaying;
              if (isPlaying != _isPlaying) {
                setState(() {
                  _isPlaying = isPlaying;
                });
              }

              if (_controller.value.isBuffering != _isBuffering) {
                setState(() {
                  _isBuffering = _controller.value.isBuffering;
                });
              }
            }
          });

          setState(() {
            _isBuffering = false;
          });

          _startHideControlsTimer();
          _animationController.forward();
        } else {
          setState(() {
            _isBuffering = false;
          });

          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.errorMessage ?? 'Failed to load video'),
                backgroundColor: result.state == VideoLoadState.networkError
                    ? Colors.orange
                    : Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () => _initializeVideo(),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBuffering = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video error: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _initializeVideo(),
            ),
          ),
        );
      }
    }
  }

  void _startHideControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
        _animationController.reverse();
      }
    });
  }

  void _startExerciseTimer() {
    if (_timerActive) return;

    _timerActive = true;
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _exerciseTimer?.cancel();
        widget.changePageIndex();
      }
    });
  }

  void _pauseExerciseTimer() {
    _exerciseTimer?.cancel();
    _timerActive = false;
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        if (widget.isTimeBased) _pauseExerciseTimer();
      } else {
        _controller.play();
        if (widget.isTimeBased) _startExerciseTimer();
        _startHideControlsTimer();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _animationController.forward();
        _startHideControlsTimer();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _setPlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _controller.setPlaybackSpeed(speed);
    });
    _startHideControlsTimer();
  }

  void _rewind() {
    final newPosition =
        _controller.value.position - const Duration(seconds: 10);
    _controller
        .seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
    _startHideControlsTimer();
  }

  void _fastForward() {
    final newPosition =
        _controller.value.position + const Duration(seconds: 10);
    _controller.seekTo(newPosition > _controller.value.duration
        ? _controller.value.duration
        : newPosition);
    _startHideControlsTimer();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  Color get _phaseColor {
    // Always return primary blue for consistency
    return UiColors().primaryBlue;
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _exerciseTimer?.cancel();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.black,
      child: SizedBox.expand(
        child: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              // Video player
              Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),

              // Buffering indicator
              if (_isBuffering && _controller.value.isInitialized)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),

              // Exercise timer (for time-based exercises)
              if (widget.isTimeBased && _remainingSeconds > 0)
                Positioned(
                  top: 100,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Time Remaining',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            color: _remainingSeconds < 10
                                ? Colors.red
                                : Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Controls overlay
              FadeTransition(
                opacity: _animation,
                child: Visibility(
                  visible: _showControls,
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Stack(
                      children: [
                        // Top bar with title and exercise type
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.arrow_back,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: UiColors().primaryBlue,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            widget.workoutType == "warmUp"
                                                ? 'WARM-UP'
                                                : widget.workoutType ==
                                                        "workouts"
                                                    ? "WORKOUT"
                                                    : "COOL-DOWN",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          widget.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Center play/pause button
                        Center(
                          child: IconButton(
                            onPressed: _togglePlayPause,
                            icon: Icon(
                              _isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white,
                              size: 72,
                            ),
                          ),
                        ),

                        // Bottom controls
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Exercise info (reps or time)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _phaseColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      widget.isTimeBased
                                          ? "Duration: ${_formatTime(widget.duration)}"
                                          : "Rep ${widget.repsCounter} / ${widget.reps}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Video progress
                                  Row(
                                    children: [
                                      Text(
                                        _controller.value.isInitialized
                                            ? _formatDuration(
                                                _controller.value.position)
                                            : '00:00',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 6),
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                                    overlayRadius: 12),
                                            trackHeight: 4,
                                            activeTrackColor: UiColors().teal,
                                            inactiveTrackColor: Colors.white24,
                                            thumbColor: UiColors().teal,
                                            overlayColor: UiColors()
                                                .teal
                                                .withOpacity(0.3),
                                          ),
                                          child: Slider(
                                            value:
                                                _controller.value.isInitialized
                                                    ? _controller.value.position
                                                        .inMilliseconds
                                                        .toDouble()
                                                    : 0,
                                            min: 0,
                                            max: _controller.value.isInitialized
                                                ? _controller.value.duration
                                                    .inMilliseconds
                                                    .toDouble()
                                                : 100,
                                            onChanged: (value) {
                                              final position = Duration(
                                                  milliseconds: value.toInt());
                                              _controller.seekTo(position);
                                              _startHideControlsTimer();
                                            },
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _controller.value.isInitialized
                                            ? _formatDuration(
                                                _controller.value.duration)
                                            : '00:00',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Video controls
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: _rewind,
                                        icon: const Icon(Icons.replay_10,
                                            color: Colors.white, size: 32),
                                      ),
                                      IconButton(
                                        onPressed: _togglePlayPause,
                                        icon: Icon(
                                          _isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: _fastForward,
                                        icon: const Icon(Icons.forward_10,
                                            color: Colors.white, size: 32),
                                      ),
                                      PopupMenuButton<double>(
                                        color: Colors.black.withOpacity(0.8),
                                        icon: const Icon(Icons.speed,
                                            color: Colors.white),
                                        onSelected: _setPlaybackSpeed,
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 0.5,
                                            child: Text('0.5x',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          const PopupMenuItem(
                                            value: 0.75,
                                            child: Text('0.75x',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          const PopupMenuItem(
                                            value: 1.0,
                                            child: Text('1.0x',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          const PopupMenuItem(
                                            value: 1.25,
                                            child: Text('1.25x',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          const PopupMenuItem(
                                            value: 1.5,
                                            child: Text('1.5x',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _phaseColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () =>
                                            widget.changePageIndex(),
                                        child: const Text('NEXT'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Exercise description
                                  if (widget.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        widget.description,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
