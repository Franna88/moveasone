import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:async';

const YOUR_ZEGO_APP_ID =
    1; // Placeholder - replace with your actual Zego App ID
const YOUR_ZEGO_APP_SIGN =
    'placeholder'; // Placeholder - replace with your actual Zego App Sign

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
  bool _isInitialized = false;
  Map<String, DateTime> _messageTimestamps = {};

  @override
  void initState() {
    super.initState();
    _initializeWorkshopRoom();
  }

  Future<void> _initializeWorkshopRoom() async {
    try {
      // Add user presence to workshop
      if (_auth.currentUser != null) {
        await _firestore.collection('workshops').doc(widget.workshopId).update({
          'activeParticipants': FieldValue.arrayUnion([
            {
              'id': _auth.currentUser!.uid,
              'name': _auth.currentUser!.displayName ?? 'Anonymous',
              'joinedAt': DateTime.now().toIso8601String(),
            }
          ]),
        });
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing workshop room: $e');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _removeUserPresence();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _removeUserPresence() async {
    try {
      if (_auth.currentUser != null) {
        await _firestore.collection('workshops').doc(widget.workshopId).update({
          'activeParticipants': FieldValue.arrayRemove([
            {
              'id': _auth.currentUser!.uid,
              'name': _auth.currentUser!.displayName ?? 'Anonymous',
            }
          ]),
        });
      }
    } catch (e) {
      print('Error removing user presence: $e');
    }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.workshopTitle,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: !_isInitialized
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Initializing workshop room...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Video Call Placeholder View
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_call,
                          size: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Workshop Room',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.workshopTitle,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Video integration coming soon',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            final timeElapsed =
                                now.difference(messageTime).inSeconds;
                            final opacity =
                                ((15 - timeElapsed) / 15).clamp(0.0, 1.0);

                            return Opacity(
                              opacity: opacity,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      isMe
                                          ? 'You: '
                                          : '${message['senderName']}: ',
                                      style: TextStyle(
                                        color: isMe
                                            ? Color(0xFF94FBAB)
                                            : Colors.white,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
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
