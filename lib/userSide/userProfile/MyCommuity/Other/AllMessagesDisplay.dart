import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/MyCommunityComponents/AllMessageUser.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class AllMessagesDisplay extends StatefulWidget {
  const AllMessagesDisplay({super.key});

  @override
  State<AllMessagesDisplay> createState() => _AllMessagesDisplayState();
}

class _AllMessagesDisplayState extends State<AllMessagesDisplay> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _friendsList = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  Future<void> _fetchFriendsList() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;

    try {
      DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      List friendsList = currentUserDoc['friendsList'];
      print('Fetched friends list: $friendsList'); // Debugging line

      setState(() {
        _friendsList = List<Map<String, dynamic>>.from(friendsList);
      });
    } catch (e) {
      print('Error fetching friends list: $e');
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat.Hm();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(
          header: 'MESSAGES',
          showBackButton: false,
        ),
        _friendsList.isEmpty
            ? Center(child: Text('No messages'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _friendsList.length,
                itemBuilder: (context, index) {
                  final friend = _friendsList[index];
                  print('Friend data: $friend'); // Debugging line

                  final messages = friend['messages'] ?? [];

                  if (messages.isEmpty) {
                    return SizedBox.shrink(); // Skip friends with no messages
                  }

                  final lastMessage = messages.last;

                  return FutureBuilder<DocumentSnapshot>(
                    future:
                        _firestore.collection('users').doc(friend['id']).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading friend data');
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Text('Friend not found');
                      }

                      final friendData = snapshot.data!;
                      print(
                          'Friend profile data: $friendData'); // Debugging line

                      final friendName =
                          friendData['name'] as String? ?? 'Unknown';
                      final friendPic = friendData['profilePic'] as String? ??
                          'images/default_avatar.jpg';

                      return AllMessageUser(
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyChat(
                                userName: friendName,
                                userPic: friendPic,
                                userId: friend['id'],
                                chatId:
                                    '', // Replace with the correct chat ID if available
                              ),
                            ),
                          );
                        },
                        userPic: friendPic,
                        userName: friendName,
                        message: lastMessage['message'] ?? 'No messages yet',
                        timeStamp: formatTimestamp(lastMessage['timestamp']),
                      );
                    },
                  );
                },
              ),
      ],
    );
  }
}
