import 'package:flutter/material.dart';

class VideoBottomButtons extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  const VideoBottomButtons(
      {super.key, required this.buttonText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: const Color.fromARGB(0, 255, 255, 255),
      shape: CircleBorder(),
      child: Container(
        height: 65,
        width: 65,
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: const Color.fromARGB(113, 255, 255, 255),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
