import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:move_as_one/commonUi/uiColors.dart';

class CircularCountdown extends StatefulWidget {
  final int duration;
  final double size;
  final Color color;

  CircularCountdown(
      {this.duration = 60,
      this.size = 115,
      this.color = const Color.fromARGB(255, 1, 102, 92)});

  @override
  _CircularCountdownState createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown> {
  double _progress = 1.0;
  late Timer _timer;
  late int _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_currentTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _currentTime--;
            _progress = _currentTime / widget.duration;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 7,
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              backgroundColor: Color.fromARGB(204, 202, 201, 201),
            ),
          ),
          Text(
            '00:$_currentTime',
            style: TextStyle(
                fontSize: 30, color: const Color.fromARGB(255, 1, 102, 92)),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      
      body: CircularCountdown(),
    ),
  ));
}
