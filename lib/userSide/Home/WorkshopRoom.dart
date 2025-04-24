import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:async';

const YOUR_ZEGO_APP_ID =
    1234567890; // Replace with your actual App ID (must be a number)
const YOUR_ZEGO_APP_SIGN =
    'abcdef1234567890abcdef1234567890'; // Replace with your actual App Sign

class WorkshopRoom extends StatefulWidget {
  final String workshopId;
  final String workshopTitle;
  final bool isHost;

  const WorkshopRoom({
    Key? key,
    required this.workshopId,
    required this.workshopTitle,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<WorkshopRoom> createState() => _WorkshopRoomState();
}

class _WorkshopRoomState extends State<WorkshopRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInputActive = false;
  Map<String, DateTime> _messageTimestamps = {};

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final timestamp = DateTime.now();
      final messageRef = await _firestore
          .collection('workshops')
          .doc(widget.workshopId)
          .collection('messages')
          .add({
        'text': _messageController.text,
        'senderId': _auth.currentUser?.uid,
        'senderName': _auth.currentUser?.displayName ?? 'Anonymous',
        'timestamp': timestamp,
      });

      setState(() {
        _messageTimestamps[messageRef.id] = timestamp;
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  bool _shouldShowMessage(String messageId, DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inSeconds <= 15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Call View
          ZegoUIKitPrebuiltCall(
            appID: YOUR_ZEGO_APP_ID,
            appSign: YOUR_ZEGO_APP_SIGN,
            userID: _auth.currentUser?.uid ?? 'anonymous',
            userName: _auth.currentUser?.displayName ?? 'Anonymous',
            callID: widget.workshopId,
            config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(),
          ),

          // Chat Messages Overlay
          Positioned(
            left: 16,
            right: 16,
            bottom: _isInputActive ? 80 : 60,
            child: SizedBox(
              height: 120,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('workshops')
                    .doc(widget.workshopId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }

                  final messages = snapshot.data!.docs;
                  final now = DateTime.now();

                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.zero,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final doc = messages[index];
                      final message = doc.data() as Map<String, dynamic>;
                      final isMe =
                          message['senderId'] == _auth.currentUser?.uid;

                      if (!_messageTimestamps.containsKey(doc.id)) {
                        _messageTimestamps[doc.id] =
                            (message['timestamp'] as Timestamp).toDate();
                        Future.delayed(Duration(seconds: 15), () {
                          if (mounted) {
                            setState(() {
                              _messageTimestamps.remove(doc.id);
                            });
                          }
                        });
                      }

                      if (!_messageTimestamps.containsKey(doc.id) ||
                          !_shouldShowMessage(
                              doc.id, _messageTimestamps[doc.id]!)) {
                        return SizedBox();
                      }

                      final messageTime = _messageTimestamps[doc.id]!;
                      final timeElapsed = now.difference(messageTime).inSeconds;
                      final opacity = ((15 - timeElapsed) / 15).clamp(0.0, 1.0);

                      return Opacity(
                        opacity: opacity,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                isMe ? 'You: ' : '${message['senderName']}: ',
                                style: TextStyle(
                                  color:
                                      isMe ? Color(0xFF94FBAB) : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  message['text'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Chat Input Field
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _isInputActive
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            autofocus: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (text) {
                              _sendMessage();
                              setState(() {
                                _isInputActive = false;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            _sendMessage();
                            setState(() {
                              _isInputActive = false;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isInputActive = true;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Click to chat',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
