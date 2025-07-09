import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:video_player/video_player.dart';
import '../../../../../Services/enhanced_video_service.dart';

class CreatorWorkoutCompleted extends StatefulWidget {
  final String videoUrl;
  const CreatorWorkoutCompleted({super.key, required this.videoUrl});

  @override
  _CreatorWorkoutCompletedState createState() =>
      _CreatorWorkoutCompletedState();
}

class _CreatorWorkoutCompletedState extends State<CreatorWorkoutCompleted> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
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

          _controller.addListener(() {
            if (mounted) {
              setState(() {
                _isPlaying = _controller.value.isPlaying;
              });
            }
          });

          setState(() {});
        } else {
          // Handle error - show placeholder
          print('Failed to load video: ${result.errorMessage}');
          // Create a dummy controller to prevent null errors
          _controller = VideoPlayerController.networkUrl(Uri.parse(''));
          setState(() {});
        }
      }
    } catch (e) {
      print('Video initialization error: $e');
      // Create a dummy controller to prevent null errors
      _controller = VideoPlayerController.networkUrl(Uri.parse(''));
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: heightDevice,
        width: widthDevice,
        child: Stack(
          children: [
            _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/placeHolder1.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!_isPlaying) ...[
                    CommonOverlayHeader(
                        header: 'WORKOUT', textColor: UiColors().teal),
                    SizedBox(
                      height: heightDevice * 0.10,
                    ),
                    Text(
                      'Well done!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Workout Completed.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: heightDevice * 0.20,
                    ),
                  ],
                  if (!_isPlaying) ...[
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NavVideoButton(
                              buttonColor: UiColors().teal,
                              buttonText: 'Watch',
                              onTap: () {
                                setState(() {
                                  _controller.play();
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            NavVideoButton(
                              buttonColor: UiColors().teal,
                              buttonText: 'Save Video',
                              onTap: () {
                                Navigator.pop(context);
                                /*   Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CoolDownOverlay(),
                                  ),
                                );*/
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NavVideoButton(
                              buttonColor: UiColors().brown,
                              buttonText: 'Cancel',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
