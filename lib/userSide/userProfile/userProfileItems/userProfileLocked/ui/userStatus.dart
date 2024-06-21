import 'package:flutter/material.dart';

class UserStatus extends StatelessWidget {
  final String userStatus;
  const UserStatus({super.key, required this.userStatus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical:  15),
      child: Text(
        textAlign: TextAlign.start,
        userStatus,
        style: TextStyle(
          fontFamily: 'BeVietnam',
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
