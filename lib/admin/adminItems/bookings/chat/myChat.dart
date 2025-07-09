import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/ui/bottomChatTextField.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/ui/topChatCon.dart';
import 'dart:async';

class MyChat extends StatefulWidget {
  final String userName;
  final String userPic;
  final String userId;
  final String chatId;

  const MyChat({
    super.key,
    required this.userName,
    required this.userPic,
    required this.userId,
    required this.chatId,
  });

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<DocumentSnapshot>? _typingStatusListener;
  String _activityStatus = 'Online';
  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _listenToTypingStatus();
    _updateUserOnlineStatus(true);
  }

  @override
  void dispose() {
    _typingStatusListener?.cancel();
    _updateUserOnlineStatus(false);
    _typingTimer?.cancel();
    super.dispose();
  }

  void _listenToTypingStatus() {
    _typingStatusListener = _firestore
        .collection('chatTypingStatus')
        .doc('${widget.userId}_${_auth.currentUser?.uid}')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final isTyping = data['isTyping'] ?? false;
        final lastSeen = data['lastSeen'] as Timestamp?;

        setState(() {
          if (isTyping) {
            _activityStatus = 'typing...';
            _isTyping = true;
          } else {
            _isTyping = false;
            if (lastSeen != null) {
              final now = DateTime.now();
              final lastSeenTime = lastSeen.toDate();
              final difference = now.difference(lastSeenTime);

              if (difference.inMinutes < 1) {
                _activityStatus = 'Online';
              } else if (difference.inMinutes < 60) {
                _activityStatus = 'Last seen ${difference.inMinutes}m ago';
              } else if (difference.inHours < 24) {
                _activityStatus = 'Last seen ${difference.inHours}h ago';
              } else {
                _activityStatus = 'Last seen ${difference.inDays}d ago';
              }
            } else {
              _activityStatus = 'Online';
            }
          }
        });
      } else {
        setState(() {
          _activityStatus = 'Online';
          _isTyping = false;
        });
      }
    });
  }

  void _updateUserOnlineStatus(bool isOnline) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('chatTypingStatus')
          .doc('${currentUser.uid}_${widget.userId}')
          .set({
        'userId': currentUser.uid,
        'isTyping': false,
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  void _updateTypingStatus(bool isTyping) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('chatTypingStatus')
          .doc('${currentUser.uid}_${widget.userId}')
          .set({
        'userId': currentUser.uid,
        'isTyping': isTyping,
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating typing status: $e');
    }
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty && !_isTyping) {
      _updateTypingStatus(true);
      setState(() {
        _isTyping = true;
      });
    }

    // Cancel previous timer
    _typingTimer?.cancel();

    // Set new timer to stop typing status after 2 seconds of inactivity
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _updateTypingStatus(false);
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopChatCon(
              userName: widget.userName,
              userPic: widget.userPic,
              activityStatus: _activityStatus,
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userDoc = snapshot.data!;
                  final friendsList =
                      userDoc['friendsList'] as List<dynamic>? ?? [];
                  final friend = friendsList.firstWhere(
                    (f) => f['id'] == widget.userId,
                    orElse: () => null,
                  );

                  if (friend == null || !friend.containsKey('messages')) {
                    return const Center(child: Text('No messages found'));
                  }

                  final messages = friend['messages'] as List<dynamic>;

                  return ListView.builder(
                    reverse: true, // Show latest messages at bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isMe = message['senderId'] == currentUser.uid;
                      final messageText = message['message'];

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            BottomChatTextField(
              receiverId: widget.userId,
              receiverName: widget.userName,
              receiverPic: widget.userPic,
              chatId: widget.chatId,
              onTextChanged: _onTextChanged,
            ),
          ],
        ),
      ),
    );
  }
}
