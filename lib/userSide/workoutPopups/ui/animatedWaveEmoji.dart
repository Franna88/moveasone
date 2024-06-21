import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';





class AnimatedWaveEmoji extends StatefulWidget {
  @override
  _AnimatedWaveEmojiState createState() =>
      _AnimatedWaveEmojiState();
}

class _AnimatedWaveEmojiState extends State<AnimatedWaveEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller.repeat(reverse: true); // Repeats the animation
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 0.30, // Adjust this value for subtlety
            child: Container(
              width: 60,
              height: 60,
              
              child: Center(
                child: Image.asset('images/hiFive.png')
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}