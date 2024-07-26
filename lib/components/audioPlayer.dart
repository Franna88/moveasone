import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerPage extends StatefulWidget {
  final String? audioUrl;

  const AudioPlayerPage({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Future<void> setAudio() async {}

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(widget.audioUrl!);
    setAudio();

    audioPlayer.playerStateStream.listen((PlayerState state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await audioPlayer.play();
  }

  Future<void> _pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> _stopAudio() async {
    await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            activeColor: Colors.white,
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35,
            child: IconButton(
              color: Colors.brown[300],
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 50,
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.play();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
