import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:move_as_one/userSide/userProfile/MyCommuity/MyCommunityComponents/FriendsList.dart';
import 'package:move_as_one/userSide/userProfile/Sendhi5Back/Sendhi5Back.dart';

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Center(child: Text('You must be signed in to view this page'));
    }

    return SingleChildScrollView(
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
              return Center(child: Text('No friends found'));
            }

            final userDoc = snapshot.data!;
            final friendsList = userDoc['friendsList'] as List<dynamic>? ?? [];

            final friends = friendsList.where((friend) {
              if (friend is Map<String, dynamic>) {
                return friend['status'] == 'friend';
              }
              return false;
            }).toList();

            return Column(
              children: friends.map((friend) {
                if (friend is Map<String, dynamic>) {
                  final friendId = friend['id'] as String? ?? '';

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('users').doc(friendId).get(),
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

                      final friendData = friendSnapshot.data!;
                      final friendName = friendData['name'] as String;
                      final friendPicture =
                          friendData['profilePic'] as String? ?? '';

                      return FriendsList(
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Sendhi5Back(
                                userId: friendId,
                                picture: friendPicture,
                                name: friendName,
                              ),
                            ),
                          );
                        },
                        picture: friendPicture.isNotEmpty
                            ? friendPicture
                            : 'images/default_avatar.jpg',
                        name: friendName,
                        userId: friendId, // Pass the correct friend ID
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
