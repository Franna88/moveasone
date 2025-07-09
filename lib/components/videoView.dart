import 'package:flutter/material.dart';
import 'enhanced_video_player.dart';

class VideoView extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;
  final String? thumbnailUrl;
  final double width;
  final double height;
  final bool autoPlay;
  final bool showControls;

  VideoView({
    super.key,
    required this.videoUrl,
    this.videoTitle,
    this.thumbnailUrl,
    this.width = 200,
    this.height = 200,
    this.autoPlay = false,
    this.showControls = false,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: EnhancedVideoPlayer(
          videoUrl: widget.videoUrl,
          videoTitle: widget.videoTitle,
          thumbnailUrl: widget.thumbnailUrl,
          autoPlay: widget.autoPlay,
          showControls: widget.showControls,
          enableFullScreen: false,
          onError: () {
            debugPrint('VideoView: Error loading video ${widget.videoUrl}');
          },
          onLoaded: () {
            debugPrint(
                'VideoView: Video loaded successfully ${widget.videoUrl}');
          },
          onRetry: () {
            debugPrint('VideoView: Retrying video ${widget.videoUrl}');
          },
        ),
      ),
    );
  }
}
