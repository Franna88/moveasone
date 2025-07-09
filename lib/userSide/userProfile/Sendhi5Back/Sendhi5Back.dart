import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/Hi5LastWorkout.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/Videos.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/userProfileLocked.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';

class Sendhi5Back extends StatefulWidget {
  final String userId;
  final String picture;
  final String name;
  const Sendhi5Back({
    super.key,
    required this.userId,
    required this.picture,
    required this.name,
  });

  @override
  State<Sendhi5Back> createState() => _Sendhi5BackState();
}

class _Sendhi5BackState extends State<Sendhi5Back> {
  String bio = '';
  String hiFive = '';
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          bio = data['bio'] ?? '';
          hiFive = (data['hiFive'] ?? 0).toString();
        });
      }
    }
  }

  void _openChat() async {
    if (_isNavigating) return; // Prevent double-tap

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Please sign in to send messages'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _isNavigating = true;
    });

    try {
      // Generate unique chat ID
      final chatId = (currentUser.uid.compareTo(widget.userId) > 0)
          ? '${currentUser.uid}_${widget.userId}'
          : '${widget.userId}_${currentUser.uid}';

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyChat(
            userId: widget.userId,
            userName: widget.name,
            userPic: widget.picture,
            chatId: chatId,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MyUtility(context).height * 0.05,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_arrow_left),
                  color: Colors.black,
                  iconSize: 30.0,
                ),
                Center(
                  child: Text(
                    'SEND HI-FIVE',
                    style: TextStyle(
                      color: consts.textcolor,
                      fontSize: 15,
                      fontFamily: 'BeVietnam',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MyUtility(context).height * 0.01,
            ),
            SizedBox(
              width: MyUtility(context).width / 1.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MyUtility(context).width * 0.05,
                  ),
                  ClipOval(
                    child: widget.picture.isNotEmpty
                        ? Image.network(
                            widget.picture,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXERCISES',
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '103',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HIGH FIVE’S',
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        hiFive,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 20),
              child: SizedBox(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.name,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontFamily: 'Be Vietnam',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '@anikko_334',
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 16,
                          fontFamily: 'Be Vietnam',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 20),
              child: SizedBox(
                width: 311,
                child: Text(
                  bio,
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 15,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileLocked(
                                profilePic: widget.picture,
                                name: widget.name,
                                bio: bio,
                                userId: widget.userId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF),
                      foregroundColor: Color(0xFF006261),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 17.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Color(0xFF006261),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      'Hi-Five',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Be Vietnam',
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isNavigating
                        ? null
                        : () {
                            _openChat();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF),
                      foregroundColor: Color(0xFF006261),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 17.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Color(0xFF006261),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: _isNavigating
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF006261)),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Opening...',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Be Vietnam',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Send message',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Be Vietnam',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF1E1E1E),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.02,
            ),
            Videos(userId: widget.userId),
            Hi5LastWorkout(userId: widget.userId)
          ],
        ),
      ),
    );
  }
}
