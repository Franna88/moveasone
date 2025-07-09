import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/MyCommunityComponents/PendingRequests.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({super.key});

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Center(child: Text('You must be signed in to view this page'));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream:
                _firestore.collection('users').doc(currentUser.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No pending requests found'));
              }

              final userDoc = snapshot.data!;
              final friendsList =
                  userDoc['friendsList'] as List<dynamic>? ?? [];

              final pendingRequests = friendsList.where((friend) {
                if (friend is Map<String, dynamic>) {
                  return friend['status'] == 'pending';
                }
                return false;
              }).toList();

              return Column(
                children: pendingRequests.map((friend) {
                  if (friend is Map<String, dynamic>) {
                    final friendId = friend['id'] as String? ?? '';

                    if (friendId.isNotEmpty) {
                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            _firestore.collection('users').doc(friendId).get(),
                        builder: (context, friendSnapshot) {
                          if (friendSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (friendSnapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (!friendSnapshot.hasData ||
                              !friendSnapshot.data!.exists) {
                            return Text('User not found');
                          }

                          final friendData = friendSnapshot.data!.data()
                              as Map<String, dynamic>?;
                          if (friendData == null) {
                            return Text('User data is empty');
                          }

                          final friendName =
                              friendData['name'] as String? ?? 'Unknown';
                          final friendPicture =
                              friendData['profilePic'] as String? ?? '';

                          return PendingRequests(
                            picture: friendPicture.isNotEmpty
                                ? friendPicture
                                : 'images/Avatar1.jpg',
                            name: friendName,
                            friendId: friendId,
                            onFriendAdded: _refreshPage,
                          );
                        },
                      );
                    }
                  }
                  return SizedBox.shrink();
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
