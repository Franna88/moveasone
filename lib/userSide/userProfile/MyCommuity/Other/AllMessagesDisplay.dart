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
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  Future<void> _fetchFriendsList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not signed in';
      });
      return;
    }

    final currentUserId = currentUser.uid;

    try {
      DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUserId).get();

      if (!currentUserDoc.exists ||
          !currentUserDoc.data().toString().contains('friendsList')) {
        setState(() {
          _isLoading = false;
          _friendsList = [];
        });
        return;
      }

      List friendsList = currentUserDoc['friendsList'] ?? [];
      print('Fetched friends list: $friendsList'); // Debugging line

      setState(() {
        _friendsList = List<Map<String, dynamic>>.from(friendsList);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching friends list: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
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
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child:
                    Text(_errorMessage, style: TextStyle(color: Colors.red))),
          )
        else if (_friendsList.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: Text('No messages')),
          )
        else
          ..._buildMessagesList(),
      ],
    );
  }

  List<Widget> _buildMessagesList() {
    final List<Widget> messageWidgets = [];

    for (int index = 0; index < _friendsList.length; index++) {
      final friend = _friendsList[index];
      final messages = friend['messages'] ?? [];

      if (messages.isEmpty) {
        continue; // Skip friends with no messages
      }

      final lastMessage = messages.last;

      messageWidgets.add(
        FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(friend['id']).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Text('Error loading friend data')),
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Text('Friend not found')),
              );
            }

            final friendData = snapshot.data!.data() as Map<String, dynamic>?;
            if (friendData == null) {
              return SizedBox.shrink();
            }

            final friendName = friendData['name'] as String? ?? 'Unknown';
            final friendPic =
                friendData['profilePic'] as String? ?? 'images/Avatar1.jpg';

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
              timeStamp: lastMessage['timestamp'] is Timestamp
                  ? formatTimestamp(lastMessage['timestamp'])
                  : 'Unknown time',
            );
          },
        ),
      );
    }

    return messageWidgets;
  }
}
