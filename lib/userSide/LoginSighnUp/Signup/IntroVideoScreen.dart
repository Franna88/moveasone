import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart'; // Adjust the import based on your file structure
//import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';
import 'package:move_as_one/Services/auth_services.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/Signup.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/Goal.dart';

class IntroVideoScreen extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? password;
  final String? goal;
  final String? weight;
  final String? gender;
  final String? age;
  final String? height;
  final String? weightUnit;
  final String? activityLevel;

  const IntroVideoScreen({
    Key? key,
    this.userName,
    this.email,
    this.password,
    this.goal,
    this.weight,
    this.gender,
    this.age,
    this.height,
    this.weightUnit,
    this.activityLevel,
  }) : super(key: key);

  @override
  _IntroVideoScreenState createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _controller;
  bool _showControls = false;
  bool _hasNavigated = false;
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
      // Check if video has actually finished playing and we haven't navigated yet
      if (!_hasNavigated &&
          _controller.value.isInitialized &&
          _controller.value.duration.inMilliseconds > 0 &&
          _controller.value.position.inMilliseconds >=
              _controller.value.duration.inMilliseconds - 100) {
        _hasNavigated = true; // Prevent multiple navigations

        // AutoOrientation
        //     .portraitAutoMode(); // Switch back to portrait orientation
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values); // Disable fullscreen mode

        // If signup parameters are provided (coming from sign up button), proceed with signup
        if (widget.userName != null &&
            widget.email != null &&
            widget.password != null) {
          _proceedWithSignup();
        }
        // If user data is provided (coming from analysis screen), navigate to signup form
        else if (widget.goal != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Signup(
                      goal: widget.goal!,
                      gender: widget.gender!,
                      age: widget.age!,
                      height: widget.height!,
                      weight: widget.weight!,
                      weightUnit: widget.weightUnit!,
                      activityLevel: widget.activityLevel!,
                    )),
          );
        }
        // Otherwise, navigate to goal selection (start info quiz) - coming from signin "Sign up" button
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Goal()),
          );
        }
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

  void _proceedWithSignup() async {
    if (widget.userName != null &&
        widget.email != null &&
        widget.password != null) {
      await AuthService().Signup(
        userName: widget.userName!,
        email: widget.email!,
        password: widget.password!,
        goal: widget.goal ?? '',
        weight: widget.weight ?? '',
        gender: widget.gender ?? '',
        age: widget.age ?? '',
        height: widget.height ?? '',
        weightUnit: widget.weightUnit ?? '',
        activityLevel: widget.activityLevel ?? '',
        context: context,
      );
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
              // Back button - always visible
              Positioned(
                top: 40,
                left: 16,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      // Restore system UI mode before navigating back
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                          overlays: SystemUiOverlay.values);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Signin()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
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
