import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;

class FriendsList extends StatefulWidget {
  final VoidCallback onPress;
  final String picture;
  final String name;
  final String userId; // Add userId to pass to MyChat screen

  const FriendsList({
    super.key,
    required this.onPress,
    required this.picture,
    required this.name,
    required this.userId,
  });

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  String? _chatId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final chatId = (currentUser.uid.compareTo(widget.userId) > 0)
          ? '${currentUser.uid}_${widget.userId}'
          : '${widget.userId}_${currentUser.uid}';

      setState(() {
        _chatId = chatId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Image.network(
                  widget.picture,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
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
              ElevatedButton(
                onPressed: () {
                  if (_chatId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyChat(
                          userName: widget.name,
                          userPic: widget.picture,
                          userId: widget.userId,
                          chatId: _chatId!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF006261),
                  foregroundColor: Color(0xffffffff),
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
