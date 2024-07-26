import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class MyVoiceTimer extends StatefulWidget {
  final String audioUrl;

  const MyVoiceTimer({super.key, required this.audioUrl});

  @override
  State<MyVoiceTimer> createState() => _MyVoiceTimerState();
}

class _MyVoiceTimerState extends State<MyVoiceTimer> {
  Timer? _timer;
  late int _start;
  bool _isRunning = false;

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(widget.audioUrl);

    audioPlayer.playerStateStream.listen((PlayerState state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;

        _start = newDuration!.inSeconds;
      });
    });

    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> _playAudio() async {
    await audioPlayer.play();
  }

  Future<void> _pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> _stopAudio() async {
    await audioPlayer.stop();
  } /* */

  void _startPauseTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Text(
          _formatTime(_start),
          style: TextStyle(
              fontSize: 40,
              color: UiColors().teal,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: heightDevice * 0.15,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              _startPauseTimer();
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.play();
              }
              ;
            },
            child: Container(
              height: 150,
              width: 150,
              child: Stack(children: [
                Positioned(
                  left: 2,
                  child: Container(
                    height: 145,
                    width: 145,
                    decoration: ShapeDecoration(
                      color: Color.fromARGB(54, 0, 150, 135),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 9,
                  top: 7,
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: ShapeDecoration(
                      color: Color.fromARGB(110, 0, 150, 135),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 17,
                  child: Container(
                    width: 115,
                    height: 115,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.mic_none_sharp,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
