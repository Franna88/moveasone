import 'package:flutter/material.dart';

class ProfileProtected extends StatelessWidget {
  const ProfileProtected({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.lock,
          color: Colors.grey,
          size: 30,
        ),
        const SizedBox(height: 15,),
        Text(
          'This profile is protected',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
