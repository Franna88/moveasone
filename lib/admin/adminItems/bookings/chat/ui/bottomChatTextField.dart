import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomChatTextField extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String receiverName;
  final String receiverPic;

  const BottomChatTextField({
    super.key,
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
  });

  @override
  _BottomChatTextFieldState createState() => _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends State<BottomChatTextField> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final message = _controller.text.trim();
    _controller.clear();

    final currentUserId = currentUser.uid;
    final receiverId = widget.receiverId;

    try {
      // Get the current timestamp
      final timestamp = Timestamp.now();

      // Fetch the current user's document
      DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      List friendsList = [];
      if (currentUserDoc.data() != null &&
          currentUserDoc.data() is Map &&
          (currentUserDoc.data() as Map).containsKey('friendsList')) {
        friendsList = currentUserDoc['friendsList'] ?? [];
      }

      // Find or create the friend entry for the receiver
      var friendEntry = friendsList.firstWhere(
        (friend) => friend['id'] == receiverId,
        orElse: () => null,
      );

      if (friendEntry == null) {
        friendEntry = {
          'id': receiverId,
          'status': 'friend',
          'messages': [],
        };
        friendsList.add(friendEntry);
      } else {
        // Ensure status is 'friend'
        friendEntry['status'] = 'friend';
        // Ensure messages array exists
        if (friendEntry['messages'] == null ||
            friendEntry['messages'] is! List) {
          friendEntry['messages'] = [];
        }
      }

      // Add the message to the friend's messages
      (friendEntry['messages'] as List).add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp,
      });

      // Update the current user's friendsList
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .update({'friendsList': friendsList});

      // Fetch the receiver user's document
      DocumentSnapshot receiverUserDoc =
          await _firestore.collection('users').doc(receiverId).get();
      List receiverFriendsList = [];
      if (receiverUserDoc.data() != null &&
          receiverUserDoc.data() is Map &&
          (receiverUserDoc.data() as Map).containsKey('friendsList')) {
        receiverFriendsList = receiverUserDoc['friendsList'] ?? [];
      }

      // Find or create the friend entry for the current user
      var receiverFriendEntry = receiverFriendsList.firstWhere(
        (friend) => friend['id'] == currentUserId,
        orElse: () => null,
      );

      if (receiverFriendEntry == null) {
        receiverFriendEntry = {
          'id': currentUserId,
          'status': 'friend',
          'messages': [],
        };
        receiverFriendsList.add(receiverFriendEntry);
      } else {
        // Ensure status is 'friend'
        receiverFriendEntry['status'] = 'friend';
        // Ensure messages array exists
        if (receiverFriendEntry['messages'] == null ||
            receiverFriendEntry['messages'] is! List) {
          receiverFriendEntry['messages'] = [];
        }
      }

      // Add the message to the receiver's friend's messages
      (receiverFriendEntry['messages'] as List).add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp,
      });

      // Update the receiver user's friendsList
      await _firestore
          .collection('users')
          .doc(receiverId)
          .update({'friendsList': receiverFriendsList});
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(
          Icons.add,
          size: 30,
        ),
        Container(
          width: widthDevice * 0.86,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Container(
                width: widthDevice * 0.76,
                child: TextField(
                  controller: _controller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: ShapeDecoration(
                    color: Colors.teal,
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.send, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
