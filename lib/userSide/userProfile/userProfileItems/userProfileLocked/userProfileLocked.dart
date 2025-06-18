import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/exercisesAmount.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/hiFiveAmount.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/profileHeader.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/profileInteractButton.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/profileProtected.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/userImage.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/userNameTag.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/userStatus.dart';
import 'package:move_as_one/userSide/workoutPopups/popUpItems/hiFivePopUp.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';

class UserProfileLocked extends StatefulWidget {
  final String profilePic;
  final String name;
  final String bio;
  final String userId;

  const UserProfileLocked({
    Key? key,
    required this.profilePic,
    required this.name,
    required this.bio,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserProfileLocked> createState() => _UserProfileLockedState();
}

class _UserProfileLockedState extends State<UserProfileLocked> {
  int hiFiveCount = 0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchHiFiveCount();
    _listenForHiFives();
  }

  Future<void> _fetchHiFiveCount() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (userSnapshot.exists) {
      setState(() {
        hiFiveCount =
            (userSnapshot.data() as Map<String, dynamic>)['hiFive'] ?? 0;
      });
    }
  }

  Future<void> _sendHiFive() async {
    if (currentUser == null) return;

    DocumentReference recipientRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(recipientRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      int newHiFiveCount =
          (snapshot.data() as Map<String, dynamic>)['hiFive'] + 1;
      transaction.update(recipientRef, {'hiFive': newHiFiveCount});

      // Add a new hi-five notification to the recipient's notifications collection
      transaction.set(recipientRef.collection('hiFiveNotifications').doc(), {
        'senderId': currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });

    setState(() {
      hiFiveCount++;
    });

    // Show SnackBar with a message and an icon
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.front_hand_sharp, color: Colors.yellow),
            SizedBox(width: 10),
            Text('Hi-Five sent!'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _listenForHiFives() {
    if (currentUser == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('hiFiveNotifications')
        .snapshots()
        .listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          String senderId = docChange.doc['senderId'];
          // Show the popup only if the notification is not from the current user
          if (currentUser!.uid != senderId) {
            showDialog(
              context: context,
              builder: (context) => HiFivePopUp(senderName: 'Someone'),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MainContainer(
        children: [
          ProfileHeader(header: 'SEND HI-FIVE'),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserImage(userImage: widget.profilePic),
                const SizedBox(width: 30),
                ExercisesAmount(amountOfExercises: '103'),
                const SizedBox(width: 30),
                HiFiveAmount(hiFivesAmount: '$hiFiveCount'),
              ],
            ),
          ),
          UserNameTag(userName: widget.name, userTag: '@anikko_334'),
          Align(
            alignment: Alignment.centerLeft,
            child: UserStatus(userStatus: widget.bio),
          ),
          ProfileInteractButton(
            buttonChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Send Hi-Five',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.front_hand_sharp,
                  color: Colors.yellow,
                ),
              ],
            ),
            onTap: _sendHiFive,
          ),
          ProfileInteractButton(
            buttonChild: Text(
              'Send Congrats',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BeVietnam',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onTap: () {
              // Add logic here if needed
            },
          ),
          ProfileInteractButton(
            buttonChild: Text(
              'Send Well done',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BeVietnam',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onTap: () {
              // Add logic here if needed
            },
          ),
          ProfileInteractButton(
            buttonChild: Text(
              'Send message',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BeVietnam',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onTap: () {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                final chatId = (currentUser.uid.compareTo(widget.userId) > 0)
                    ? '${currentUser.uid}_${widget.userId}'
                    : '${widget.userId}_${currentUser.uid}';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyChat(
                      userName: widget.name,
                      userPic: widget.profilePic,
                      userId: widget.userId,
                      chatId: chatId,
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: heightDevice * 0.06),
          ProfileProtected(),
        ],
      ),
    );
  }
}
