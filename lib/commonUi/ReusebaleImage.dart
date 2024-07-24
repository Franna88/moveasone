import 'package:flutter/material.dart';

class VideoButton extends StatelessWidget {
  final bool isSelected;
  final String videoUrl;
  final String thumbnailUrl;
  final String description;
  final VoidCallback onTap;

  const VideoButton({
    Key? key,
    required this.isSelected,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 37,
                  backgroundColor:
                      isSelected ? Colors.blue : Colors.transparent,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(3.0), // Adjust padding as needed
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors
                          .white, // White space between thumbnail and blue outline
                      backgroundImage: NetworkImage(thumbnailUrl),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
