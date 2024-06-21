import 'package:flutter/material.dart';

class VideoDetails extends StatelessWidget {
  final String videoTitle;
  final String videoDescription;
  const VideoDetails(
      {super.key, required this.videoDescription, required this.videoTitle});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: widthDevice,
          child: Text(
            videoTitle,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: widthDevice,
          child: Text(
            videoDescription,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        )
      ],
    );
  }
}
