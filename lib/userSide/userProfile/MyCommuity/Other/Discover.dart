import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/MyCommunityComponents/NotFriends.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> currentUserFriends = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserFriends();
  }

  void _fetchCurrentUserFriends() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final userRef = _firestore.collection('users').doc(currentUser.uid);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final friendsList = List<Map<String, dynamic>>.from(
            userSnapshot.get('friendsList') as List<dynamic>);
        setState(() {
          currentUserFriends = friendsList
              .where((friend) => friend['status'] == 'friend')
              .map((friend) => friend['id'] as String)
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Center(child: Text('You must be signed in to view this page'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .where(FieldPath.documentId, isNotEqualTo: currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No users found'));
            }

            final users = snapshot.data!.docs;
            final filteredUsers = users.where((user) {
              final userId = user.id;
              return !currentUserFriends.contains(userId);
            }).toList();

            return Column(
              children: filteredUsers.map((user) {
                final userId = user.id;

                // Cast user data to Map<String, dynamic>
                final userData = user.data() as Map<String, dynamic>;

                final userName = userData['name'] ??
                    'No Name'; // Default if 'name' is missing
                final userPicture = userData.containsKey('profilePic')
                    ? userData['profilePic'] ?? ''
                    : ''; // Provide default value if profilePic is missing

                return NotFriends(
                  picture: userPicture.isNotEmpty
                      ? userPicture
                      : '', // Provide default picture if needed
                  name: userName,
                  userId: userId,
                  onPressed: () {},
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
