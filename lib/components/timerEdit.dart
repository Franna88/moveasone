import 'dart:async';

import 'package:flutter/material.dart';

import '../commonUi/uiColors.dart';

class TimeEdit extends StatefulWidget {
  int timeCountDown;
  TimeEdit({super.key, required this.timeCountDown});

  @override
  State<TimeEdit> createState() => _TimeEditState();
}

class _TimeEditState extends State<TimeEdit> {
  Timer? _timer;
  int _start = 0;
  bool _isRunning = false;

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
  void initState() {
    _start = widget.timeCountDown;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
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
              color: Colors.transparent,
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
              color: Colors.transparent,
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                _formatTime(_start),
                style: TextStyle(
                    fontSize: 40,
                    color: UiColors().teal,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

String _formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
