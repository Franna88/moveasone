import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String userImage;
  const UserImage({super.key, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 33,
              backgroundImage: AssetImage(userImage),
            );
  }
}