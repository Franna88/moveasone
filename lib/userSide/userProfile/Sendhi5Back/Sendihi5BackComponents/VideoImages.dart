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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MyUtility(context).height * 0.15,
        width: MyUtility(context).width / 3.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(widget.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
