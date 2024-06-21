import 'package:flutter/material.dart';

class UserImageStack extends StatelessWidget {
  final String userPic;
  const UserImageStack({super.key, required this.userPic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Container(
        height: 80,
        width: 100,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 40,
              backgroundImage: AssetImage(userPic),
            ),
            Positioned(
              right: 19,
              top: 58,
              child: Container(
                height: 23,
                width: 22,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: CircleBorder(),
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 55,
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.grey,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
