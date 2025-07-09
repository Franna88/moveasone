import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class VideoImages extends StatefulWidget {
  final String image;

  const VideoImages({
    super.key,
    required this.image,
  });

  @override
  State<VideoImages> createState() => _VideoImagesState();
}

class _VideoImagesState extends State<VideoImages> {
  bool _isNetworkImage(String imagePath) {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MyUtility(context).height * 0.15,
        width: MyUtility(context).width / 3.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300], // Fallback color
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: _isNetworkImage(widget.image)
              ? Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.video_library,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF0085FF),
                          ),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                )
              : Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.video_library,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
