import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class UserNameTag extends StatelessWidget {
  final String userName;
  final String userTag;
  const UserNameTag({super.key, required this.userName, required this.userTag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            userName,
            style: TextStyle(
              fontFamily: 'BeVietnam',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            userTag,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: UiColors().textgrey,
            ),
          ),
        ],
      ),
    );
  }
}
