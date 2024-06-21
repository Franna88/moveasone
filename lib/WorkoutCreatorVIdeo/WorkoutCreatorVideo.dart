import 'dart:async';
import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:video_player/video_player.dart';

class WorkoutCreatorVideo extends StatefulWidget {
  const WorkoutCreatorVideo({Key? key}) : super(key: key);

  @override
  State<WorkoutCreatorVideo> createState() => _WorkoutCreatorVideoState();
}

class _WorkoutCreatorVideoState extends State<WorkoutCreatorVideo> {
  late VideoPlayerController _videoPlayerController;
  late Timer _timer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _timer = Timer.periodic(Duration(seconds: 1), _updatePosition);
  }

  @override
  void dispose() {
    _timer.cancel();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController =
        VideoPlayerController.asset('your_video_asset_path');
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _totalDuration = _videoPlayerController.value.duration ?? Duration.zero;
      });
    });
    _videoPlayerController.addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    if (_videoPlayerController.value.isInitialized) {
      final bool isPlaying = _videoPlayerController.value.isPlaying;
      if (isPlaying) {
        setState(() {
          _currentPosition = _videoPlayerController.value.position;
        });
      }
    }
  }

  void _updatePosition(Timer timer) {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.isPlaying) {
        setState(() {
          _currentPosition = _videoPlayerController.value.position;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyUtility(context).width,
      height: MyUtility(context).height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/thoughts.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Spacer(),
          Container(
            height: MyUtility(context).height * 0.07,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_videoPlayerController.value.isPlaying) {
                        _videoPlayerController.pause();
                      } else {
                        _videoPlayerController.play();
                      }
                    });
                  },
                  icon: Icon(_videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                ),
                Text(
                  '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                  style: TextStyle(color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    // Implement fullscreen functionality
                  },
                  icon: Icon(Icons.fullscreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return '${(duration.inHours).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
