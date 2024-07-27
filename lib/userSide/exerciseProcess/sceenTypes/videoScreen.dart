import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenThree.dart';
import 'package:move_as_one/commonUi/circularCountdown.dart';
import 'package:move_as_one/commonUi/pauseButtonCon.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:video_player/video_player.dart';

import '../../../admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import '../../../commonUi/navVideoButton.dart';

class VideoScreen extends StatefulWidget {
  Function changePageIndex;
  String videoUrl;
  String workoutType;
  String title;
  int repsCounter;
  String reps;
  String description;
  VideoScreen(
      {super.key,
      required this.changePageIndex,
      required this.videoUrl,
      required this.workoutType,
      required this.title,
      required this.repsCounter,
      required this.reps,
      required this.description});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  getVideoPosition() {
    var duration = Duration(
        milliseconds: _controller.value.position.inMilliseconds.round());
    return duration.inSeconds;
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
    return Container(
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
                      header: widget.workoutType == "warmUp"
                          ? 'WARMUP'
                          : widget.workoutType == "workouts"
                              ? "WORKOUT"
                              : "COOLDOWN",
                      textColor: UiColors().teal),
                  SizedBox(
                    height: heightDevice * 0.10,
                  ),
                ],
                if (!_isPlaying) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        textAlign: TextAlign.start,
                        "Reps ${widget.repsCounter}  / ${widget.reps}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          NavVideoButton(
                            buttonColor: UiColors().teal,
                            buttonText:
                                'Watch - ${_controller.value.duration.inMinutes} : ${_controller.value.duration.inSeconds}',
                            onTap: () {
                              setState(() {
                                _controller.play();
                              });
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              NavVideoButton(
                                buttonColor: UiColors().teal,
                                buttonText: 'Next Workout',
                                onTap: () {
                                  widget.changePageIndex();
                                },
                              )
                            ],
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
    );
  }
}
