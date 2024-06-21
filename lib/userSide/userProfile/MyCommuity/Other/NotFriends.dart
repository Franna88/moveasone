import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;

class NotFriends extends StatefulWidget {
  final String picture;
  final String name;
  final VoidCallback onPressed;

  const NotFriends(
      {super.key,
      required this.picture,
      required this.name,
      required this.onPressed});

  @override
  State<NotFriends> createState() => _NotFriendsState();
}

class _NotFriendsState extends State<NotFriends> {
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
            child: Image.asset(
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
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFFFFF),
              foregroundColor: Color(0xFF006261),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Color(0xFF006261),
                  width: 1.0,
                ),
              ),
            ),
            child: Text(
              'Not Friend',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                color: Color(0xFF006261),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
