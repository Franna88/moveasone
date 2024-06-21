import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/ui/bottomChatTextField.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/ui/topChatCon.dart';

class MyChat extends StatelessWidget {
  const MyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopChatCon(
              userName: 'Kianna Geidt',
              userPic: 'images/comment1.jpg',
              activityStatus: 'typing...',
            ),
            Spacer(),
            BottomChatTextField(),
            const SizedBox(height: 15,)
          ],
        ),
      ),
    );
  }
}
