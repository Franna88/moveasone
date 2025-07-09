import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'setsAndRepsTracker.dart';
import '../../../Services/enhanced_video_service.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/setsAndRepsTracker.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class EnhancedExerciseScreen extends StatefulWidget {
  final Map<String, dynamic> exerciseData;
  final VoidCallback onComplete;
  final Function(String) onStatusUpdate;

  const EnhancedExerciseScreen({
    Key? key,
    required this.exerciseData,
    required this.onComplete,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  State<EnhancedExerciseScreen> createState() => _EnhancedExerciseScreenState();
}

class _EnhancedExerciseScreenState extends State<EnhancedExerciseScreen> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  bool _isVideoMode = false;
  bool _isMediaLoaded = false;
  bool _isMediaPlaying = false;
  String _statusMessage = '';
  bool _isLoading = true;
  final UiColors _colors = UiColors();

  // Get phase color - always use primary blue for consistency
  Color get _phaseColor {
    return _colors.primaryBlue;
  }

  @override
  void initState() {
    super.initState();
    _initializeMedia();
    _determineMediaMode();
    _initializeExercise();
  }

  void _determineMediaMode() {
    String? videoUrl = widget.exerciseData['mediaTypeUrl'];
    String? mediaType = widget.exerciseData['mediaType'];

    _isVideoMode = (mediaType == 'Video' ||
        (videoUrl != null &&
            videoUrl.isNotEmpty &&
            videoUrl != 'file:///' &&
            videoUrl.toLowerCase().contains('.mp4')));

    print(
        'DEBUG: Media mode determined - Video: $_isVideoMode, URL: $videoUrl');
  }

  void _initializeMedia() {
    String? mediaUrl = widget.exerciseData['mediaTypeUrl'];

    if (mediaUrl == null || mediaUrl.isEmpty || mediaUrl == 'file:///') {
      print('DEBUG: No valid media URL found');
      setState(() {
        _isMediaLoaded = true;
        _statusMessage = 'No media available - follow instructions';
      });
      return;
    }

    if (_isVideoMode) {
      _initializeVideo(mediaUrl);
    } else {
      _initializeAudio(mediaUrl);
    }
  }

  void _initializeVideo(String videoUrl) async {
    try {
      print('DEBUG: Initializing video with URL: $videoUrl');

      setState(() {
        _isMediaLoaded = false;
        _statusMessage = 'Loading video...';
      });

      // Use EnhancedVideoService for robust video loading
      final videoService = EnhancedVideoService();
      final result = await videoService.loadVideo(
        videoUrl: videoUrl,
        timeout: const Duration(seconds: 30),
        maxRetries: 3,
        checkConnectivity: true,
      );

      if (mounted) {
        if (result.state == VideoLoadState.loaded &&
            result.controller != null) {
          _videoController = result.controller!;
          setState(() {
            _isMediaLoaded = true;
            _statusMessage = 'Video loaded - tap to play';
          });
          print('DEBUG: Video loaded successfully');
        } else {
          print('DEBUG: Video loading failed: ${result.errorMessage}');
          setState(() {
            _isMediaLoaded = true;
            _statusMessage = result.state == VideoLoadState.networkError
                ? 'Network error - check connection'
                : 'Video unavailable - follow instructions';
          });
        }
      }
    } catch (e) {
      print('DEBUG: Video setup error: $e');
      if (mounted) {
        setState(() {
          _isMediaLoaded = true;
          _statusMessage = 'Video error - follow instructions';
        });
      }
    }
  }

  void _initializeAudio(String audioUrl) {
    try {
      print('DEBUG: Initializing audio with URL: $audioUrl');
      _audioPlayer = AudioPlayer();
      _audioPlayer!.setUrl(audioUrl).then((_) {
        if (mounted) {
          setState(() {
            _isMediaLoaded = true;
            _statusMessage = 'Audio loaded - tap to play';
          });
        }
      }).catchError((error) {
        print('DEBUG: Audio initialization error: $error');
        if (mounted) {
          setState(() {
            _isMediaLoaded = true;
            _statusMessage = 'Audio unavailable - follow instructions';
          });
        }
      });
    } catch (e) {
      print('DEBUG: Audio setup error: $e');
      setState(() {
        _isMediaLoaded = true;
        _statusMessage = 'Audio error - follow instructions';
      });
    }
  }

  void _toggleMediaPlayback() {
    if (_isVideoMode && _videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        setState(() {
          _isMediaPlaying = false;
          _statusMessage = 'Video paused';
        });
      } else {
        _videoController!.play();
        setState(() {
          _isMediaPlaying = true;
          _statusMessage = 'Video playing';
        });
      }
    } else if (_audioPlayer != null) {
      if (_audioPlayer!.playing) {
        _audioPlayer!.pause();
        setState(() {
          _isMediaPlaying = false;
          _statusMessage = 'Audio paused';
        });
      } else {
        _audioPlayer!.play();
        setState(() {
          _isMediaPlaying = true;
          _statusMessage = 'Audio playing';
        });
      }
    }
  }

  void _onStatusUpdate(String status) {
    setState(() {
      _statusMessage = status;
    });
    widget.onStatusUpdate(status);
  }

  void _initializeExercise() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading exercise...';
    });

    // Simulate loading time
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _statusMessage = '';
      });
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Workout?'),
          content: const Text(
            'Are you sure you want to exit? Your progress will not be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.popUntil(
                    context, (route) => route.isFirst); // Exit to home
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.exerciseData['name'] ?? 'Exercise'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            if (_statusMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: _phaseColor.withOpacity(0.1),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _phaseColor,
                  ),
                ),
              ),

            // Media section
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildMediaWidget(),
                ),
              ),
            ),

            // Sets and Reps Tracker
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                child: SetsAndRepsTracker(
                  exerciseName: widget.exerciseData['name'] ?? 'Exercise',
                  totalSets: int.tryParse(
                          widget.exerciseData['setTotal']?.toString() ?? '1') ??
                      1,
                  repsPerSet: int.tryParse(
                          widget.exerciseData['repsTotal']?.toString() ??
                              '1') ??
                      1,
                  exerciseDuration: widget.exerciseData['duration'] ?? 30,
                  isTimeBased: widget.exerciseData['isTimeBased'] ?? false,
                  restBetweenSets: widget.exerciseData['timer'] ?? 30,
                  workoutType: widget.exerciseData['type'] ?? 'workouts',
                  onComplete: widget.onComplete,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaWidget() {
    if (!_isMediaLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_isVideoMode &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          // Play/pause overlay
          GestureDetector(
            onTap: _toggleMediaPlayback,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isMediaPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Fallback for audio or missing media
    return GestureDetector(
      onTap: _toggleMediaPlayback,
      child: Container(
        color: Colors.grey[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exercise image if available
            if (widget.exerciseData['image'] != null &&
                widget.exerciseData['image'].isNotEmpty &&
                !widget.exerciseData['image']
                    .toString()
                    .contains('placeholder'))
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.exerciseData['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Media icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isVideoMode
                    ? (_isMediaPlaying ? Icons.pause : Icons.play_arrow)
                    : (_isMediaPlaying ? Icons.pause : Icons.volume_up),
                color: Colors.white,
                size: 48,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _isVideoMode
                  ? (_isMediaPlaying ? 'Video Playing' : 'Tap to Play Video')
                  : (_isMediaPlaying ? 'Audio Playing' : 'Tap to Play Audio'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.exerciseData['description'] ??
                  'Follow the exercise instructions',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
