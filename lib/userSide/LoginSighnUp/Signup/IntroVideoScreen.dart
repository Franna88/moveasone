import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart'; // Adjust the import based on your file structure
//import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';

class IntroVideoScreen extends StatefulWidget {
  @override
  _IntroVideoScreenState createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _controller;
  bool _showControls = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    //AutoOrientation.landscapeAutoMode(); // Force landscape orientation
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky); // Enable fullscreen mode

    _controller = VideoPlayerController.asset('images/MaoIntroVideo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // AutoOrientation
        //     .portraitAutoMode(); // Switch back to portrait orientation
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values); // Disable fullscreen mode
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _timer?.cancel();
      _timer = Timer(Duration(seconds: 2), () {
        setState(() {
          _showControls = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    //AutoOrientation.portraitAutoMode(); // Ensure portrait orientation on exit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // Disable fullscreen mode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // AutoOrientation
        //     .portraitAutoMode(); // Ensure portrait orientation on exit
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values); // Disable fullscreen mode
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              _showControls
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.black26,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                            ),
                            Slider(
                              value: _controller.value.position.inSeconds
                                  .toDouble(),
                              max: _controller.value.duration.inSeconds
                                  .toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  _controller
                                      .seekTo(Duration(seconds: value.toInt()));
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
