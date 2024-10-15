import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;

class PendingRequests extends StatefulWidget {
  final String picture;
  final String name;
  final String friendId;
  final VoidCallback onFriendAdded;

  const PendingRequests({
    super.key,
    required this.picture,
    required this.name,
    required this.friendId,
    required this.onFriendAdded,
  });

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String friendRequestStatus = '';

  @override
  void initState() {
    super.initState();
    _fetchFriendRequestStatus();
  }

  void _fetchFriendRequestStatus() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userRef = _firestore.collection('users').doc(currentUser.uid);
    final userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      final friendsList = List<Map<String, dynamic>>.from(
          userSnapshot.get('friendsList') as List<dynamic>);
      final friend = friendsList.firstWhere(
          (friend) => friend['id'] == widget.friendId,
          orElse: () => {'friendRequest': ''});
      setState(() {
        friendRequestStatus = friend['friendRequest'] ?? '';
      });
    }
  }

  void _acceptFriendRequest() async {
    if (friendRequestStatus != 'received') return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userRef = _firestore.collection('users').doc(currentUser.uid);
    final friendRef = _firestore.collection('users').doc(widget.friendId);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      final friendSnapshot = await transaction.get(friendRef);

      if (userSnapshot.exists && friendSnapshot.exists) {
        // Update current user's friendsList
        final friendsList = List<Map<String, dynamic>>.from(
            userSnapshot.get('friendsList') as List<dynamic>);
        final updatedFriendsList = friendsList.map((friend) {
          if (friend['id'] == widget.friendId) {
            return {'id': widget.friendId, 'status': 'friend'};
          }
          return friend;
        }).toList();
        print('Current user\'s updated friendsList: $updatedFriendsList');

        transaction.update(userRef, {'friendsList': updatedFriendsList});

        // Update friend's friendsList
        final friendsListFriend = List<Map<String, dynamic>>.from(
            friendSnapshot.get('friendsList') as List<dynamic>);
        final updatedFriendsListFriend = friendsListFriend.map((friend) {
          if (friend['id'] == currentUser.uid) {
            return {'id': currentUser.uid, 'status': 'friend'};
          }
          return friend;
        }).toList();
        print('Friend\'s updated friendsList: $updatedFriendsListFriend');

        transaction
            .update(friendRef, {'friendsList': updatedFriendsListFriend});
      } else {
        print('One or both user documents do not exist.');
      }
    });

    // Call the callback to refresh the friends list
    widget.onFriendAdded();
  }

  void _declineFriendRequest() async {
    if (friendRequestStatus != 'received') return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userRef = _firestore.collection('users').doc(currentUser.uid);
    final friendRef = _firestore.collection('users').doc(widget.friendId);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      final friendSnapshot = await transaction.get(friendRef);

      if (userSnapshot.exists && friendSnapshot.exists) {
        // Update current user's friendsList
        final friendsList = List<Map<String, dynamic>>.from(
            userSnapshot.get('friendsList') as List<dynamic>);
        final updatedFriendsList = friendsList.where((friend) {
          return friend['id'] != widget.friendId;
        }).toList();
        print(
            'Current user\'s updated friendsList after decline: $updatedFriendsList');

        transaction.update(userRef, {'friendsList': updatedFriendsList});

        // Update friend's friendsList
        final friendsListFriend = List<Map<String, dynamic>>.from(
            friendSnapshot.get('friendsList') as List<dynamic>);
        final updatedFriendsListFriend = friendsListFriend.where((friend) {
          return friend['id'] != currentUser.uid;
        }).toList();
        print(
            'Friend\'s updated friendsList after decline: $updatedFriendsListFriend');

        transaction
            .update(friendRef, {'friendsList': updatedFriendsListFriend});
      } else {
        print('One or both user documents do not exist.');
      }
    });

    // Call the callback to refresh the friends list
    widget.onFriendAdded();
  }

  void _cancelFriendRequest() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userRef = _firestore.collection('users').doc(currentUser.uid);
    final friendRef = _firestore.collection('users').doc(widget.friendId);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      final friendSnapshot = await transaction.get(friendRef);

      if (userSnapshot.exists && friendSnapshot.exists) {
        // Update current user's friendsList
        final friendsList = List<Map<String, dynamic>>.from(
            userSnapshot.get('friendsList') as List<dynamic>);
        final updatedFriendsList = friendsList.where((friend) {
          return friend['id'] != widget.friendId;
        }).toList();
        print(
            'Current user\'s updated friendsList after cancel: $updatedFriendsList');

        transaction.update(userRef, {'friendsList': updatedFriendsList});

        // Update friend's friendsList
        final friendsListFriend = List<Map<String, dynamic>>.from(
            friendSnapshot.get('friendsList') as List<dynamic>);
        final updatedFriendsListFriend = friendsListFriend.where((friend) {
          return friend['id'] != currentUser.uid;
        }).toList();
        print(
            'Friend\'s updated friendsList after cancel: $updatedFriendsListFriend');

        transaction
            .update(friendRef, {'friendsList': updatedFriendsListFriend});
      } else {
        print('One or both user documents do not exist.');
      }
    });

    // Call the callback to refresh the friends list
    widget.onFriendAdded();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyUtility(context).width / 1.1,
      height: MyUtility(context).height * 0.1,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF006261).withOpacity(0.8),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: widget.picture.isNotEmpty
                ? Image.network(
                    widget.picture,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.person, color: Colors.grey, size: 50),
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
          if (friendRequestStatus == 'received') ...[
            GestureDetector(
              onTap: _acceptFriendRequest,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF006261),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.check, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: _declineFriendRequest,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ] else if (friendRequestStatus == 'sent')
            GestureDetector(
              onTap: _cancelFriendRequest,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.cancel, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
