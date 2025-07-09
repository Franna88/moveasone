import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/commonUi/circularCountdown.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/ui/otherTrainersContainer.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenThree.dart';
import 'package:move_as_one/commonUi/pauseButtonCon.dart';
import '../../../../../Services/enhanced_video_service.dart';

class ResultsScreenTwo extends StatefulWidget {
  final String videoUrl;

  const ResultsScreenTwo({super.key, required this.videoUrl});

  @override
  _ResultsScreenTwoState createState() => _ResultsScreenTwoState();
}

class _ResultsScreenTwoState extends State<ResultsScreenTwo> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isNotEmpty) {
      _initializeVideo();
    }
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

          // Add listener for video state changes
          _controller.addListener(() {
            if (mounted && _controller.value.isInitialized && !_isInitialized) {
              setState(() {
                _isInitialized = true;
                _controller.play();
                _isPlaying = true;
              });
            }
          });

          setState(() {
            _isInitialized = true;
            _controller.play();
            _isPlaying = true;
          });
        } else {
          print('Error loading video: ${result.errorMessage}');
          // Handle different error states
          if (result.state == VideoLoadState.networkError) {
            print('Network error - video may not be available');
          }
        }
      }
    } catch (error) {
      print('Error initializing video player: $error');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo() {
    if (_isInitialized) {
      setState(() {
        _isPlaying = true;
        _controller.play();
      });
    } else {
      // Retry initializing the video player if not already initialized
      _controller.initialize().then((_) {
        setState(() {
          _isPlaying = true;
          _controller.play();
        });
      }).catchError((error) {
        // Handle any errors during re-initialization
        print('Error re-initializing video player: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Video player container
          Positioned.fill(
            child: _isPlaying && _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(
                    color: Colors.black,
                    child: Center(
                      child: widget.videoUrl.isNotEmpty
                          ? Image.asset(
                              'images/placeHolder1.jpg',
                              fit: BoxFit.cover,
                              width: widthDevice,
                              height: heightDevice,
                            )
                          : Text(
                              'No video available',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
          ),
          // Content on top of the video
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: widthDevice * 0.80,
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'WARM UP',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: UiColors().teal,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: CircularCountdown(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    'Start',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        'Proper Form And Setup',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        '30 sec',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OtherTrainersContainer(),
                      SizedBox(
                        width: widthDevice * 0.15,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ResultsScreenTree()),
                            );
                          },
                          child: PauseButtonCon())
                    ],
                  ),
                  SizedBox(
                    height: heightDevice * 0.06,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
