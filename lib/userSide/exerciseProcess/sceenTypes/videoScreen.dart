import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  Function(int) changePageIndex;
  String videoUrl;
  VideoScreen(
      {super.key, required this.changePageIndex, required this.videoUrl});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..addListener(() {
          if (_controller.value.isInitialized && !_isInitialized) {
            setState(() {
              _isInitialized = true;
              _controller.play();
              _isPlaying = true;
            });
          }
        })
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
            _controller.play();
            _isPlaying = true;
          });
        }).catchError((error) {
          // Handle any errors during initialization
          print('Error initializing video player: $error');
        });
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
    return const Placeholder();
  }
}
