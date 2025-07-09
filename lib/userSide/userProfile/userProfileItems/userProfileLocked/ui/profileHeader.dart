import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String header;
  const ProfileHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 20),
      child: Stack(
        children: [
          // Back button positioned on the left
          Positioned(
            left: 15,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          // Centered header text
          Center(
            child: Text(
              header,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
