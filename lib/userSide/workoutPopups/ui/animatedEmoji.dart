import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedEmoji extends StatefulWidget {
  @override
  _AnimatedEmojiState createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<AnimatedEmoji> {
  bool _isExpanded = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the animation loop
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      width: _isExpanded ? 80.0 : 60.0, // Initial width is 100, expands to 200
      height:
          _isExpanded ? 80.0 : 60.0, // Initial height is 100, expands to 200
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/hiFive.png'))),
    );
  }
}
