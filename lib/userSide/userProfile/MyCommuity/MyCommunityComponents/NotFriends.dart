import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;

class NotFriends extends StatefulWidget {
  final String picture;
  final String name;
  final String userId;
  final VoidCallback onPressed;

  const NotFriends({
    super.key,
    required this.userId,
    required this.picture,
    required this.name,
    required this.onPressed,
  });

  @override
  State<NotFriends> createState() => _NotFriendsState();
}

class _NotFriendsState extends State<NotFriends> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFriend() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final currentUserId = currentUser.uid;
        final friendId = widget.userId;

        // Add friend request to the current user's friendsList
        await _firestore.collection('users').doc(currentUserId).update({
          'friendsList': FieldValue.arrayUnion([
            {
              'id': friendId,
              'status': 'pending',
              'friendRequest': 'sent',
            }
          ])
        });

        // Add friend request to the friend's friendsList
        await _firestore.collection('users').doc(friendId).update({
          'friendsList': FieldValue.arrayUnion([
            {
              'id': currentUserId,
              'status': 'pending',
              'friendRequest': 'received',
            }
          ])
        });

        // Show confirmation message
        _showSnackBar(context, 'Friend request sent');
      }
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Color(0xFF6699CC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyUtility(context).width / 1.1,
      height: MyUtility(context).height * 0.1,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF6699CC).withOpacity(0.8),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: widget.picture.isEmpty ? Colors.grey : null,
            backgroundImage:
                widget.picture.isNotEmpty ? NetworkImage(widget.picture) : null,
            child: widget.picture.isEmpty
                ? Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
          SizedBox(
            width: MyUtility(context).width * 0.42,
            child: Text(
              widget.name,
              style: TextStyle(
                color: consts.textcolor,
                fontSize: 17,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addFriend();
              widget.onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFFFFF),
              foregroundColor: Color(0xFF6699CC),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Color(0xFF6699CC),
                  width: 1.0,
                ),
              ),
            ),
            child: Text(
              'Add Friend',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                color: Color(0xFF6699CC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
