import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String userImage;
  const UserImage({super.key, required this.userImage});

  @override
  Widget build(BuildContext context) {
    bool isNetwork = userImage.isNotEmpty &&
        (userImage.startsWith('http://') || userImage.startsWith('https://'));
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 33,
      backgroundImage: isNetwork
          ? NetworkImage(userImage)
          : AssetImage('images/Avatar1.jpg') as ImageProvider,
    );
  }
}
