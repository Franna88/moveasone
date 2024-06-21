import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;

class FriendsList extends StatefulWidget {
  final String picture;
  final String name;
  final VoidCallback onPressed;

  const FriendsList(
      {super.key,
      required this.picture,
      required this.name,
      required this.onPressed});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
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
                  fontWeight: FontWeight.w300),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF006261),
              foregroundColor: Color(0xffffffff),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Friend',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
