import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../components/enhanced_video_player.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? videoName;
  final String? thumbnailUrl;

  const SimpleVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.videoName,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  _SimpleVideoPlayerState createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  @override
  void initState() {
    super.initState();

    // Lock to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Restore system UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: widget.videoName != null
            ? Text(
                widget.videoName!,
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      body: EnhancedVideoPlayer(
        videoUrl: widget.videoUrl,
        videoTitle: widget.videoName,
        thumbnailUrl: widget.thumbnailUrl,
        autoPlay: true,
        showControls: true,
        enableFullScreen: true,
        onError: () {
          // Handle error if needed
          debugPrint('Video playback error in SimpleVideoPlayer');
        },
        onLoaded: () {
          // Handle loaded if needed
          debugPrint('Video loaded successfully in SimpleVideoPlayer');
        },
        onRetry: () {
          // Handle retry if needed
          debugPrint('Video retry in SimpleVideoPlayer');
        },
      ),
    );
  }
}
