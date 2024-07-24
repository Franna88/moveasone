import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayer({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  late Timer _timer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _totalDuration = _controller.value.duration ?? Duration.zero;
        });
        _controller.play();
      });
    _controller.addListener(_videoPlayerListener);
    _timer = Timer.periodic(Duration(seconds: 1), _updatePosition);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    super.dispose();
  }

  void _videoPlayerListener() {
    if (_controller.value.isInitialized) {
      setState(() {
        _currentPosition = _controller.value.position;
      });
    }
  }

  void _updatePosition(Timer timer) {
    if (_controller.value.isInitialized) {
      setState(() {
        _currentPosition = _controller.value.position;
      });
    }
  }

  String _formatDuration(Duration duration) {
    return '${(duration.inHours).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentPosition.inSeconds.toDouble(),
                      max: _totalDuration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.fullscreen_exit, color: Colors.black),
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
