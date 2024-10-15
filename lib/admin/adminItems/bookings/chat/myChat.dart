import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/ui/bottomChatTextField.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/ui/topChatCon.dart';

class MyChat extends StatelessWidget {
  final String userName;
  final String userPic;
  final String userId;
  final String chatId;

  const MyChat({
    super.key,
    required this.userName,
    required this.userPic,
    required this.userId,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopChatCon(
              userName: userName,
              userPic: userPic,
              activityStatus: 'typing...',
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final userDoc = snapshot.data!;
                  final friendsList =
                      userDoc['friendsList'] as List<dynamic>? ?? [];
                  final friend = friendsList.firstWhere(
                    (f) => f['id'] == userId,
                    orElse: () => null,
                  );

                  if (friend == null || !friend.containsKey('messages')) {
                    return Center(child: Text('No messages found'));
                  }

                  final messages = friend['messages'] as List<dynamic>;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message['senderId'] == currentUser.uid;
                      final messageText =
                          message['message']; // Assuming the field is 'message'

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            BottomChatTextField(
              receiverId: userId,
              receiverName: userName,
              receiverPic: userPic,
              chatId: chatId,
            ),
          ],
        ),
      ),
    );
  }
}
