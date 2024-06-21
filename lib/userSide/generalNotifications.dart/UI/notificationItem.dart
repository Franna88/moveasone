import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class NotitficationItem extends StatelessWidget {
  final String userPic;
  final String userName;
  final String notification;
  final String timeStamp;
  const NotitficationItem(
      {super.key,
      required this.userPic,
      required this.userName,
      required this.notification,
      required this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 19,
                  backgroundImage: AssetImage(userPic),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontFamily: 'BeVietnam',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    
                    Text(
                      notification,
                      style: TextStyle(
                        fontFamily: 'Inter',
                          fontSize: 12,
                          color: UiColors().textgrey,
                          //fontWeight: FontWeight.w400
                          ),
                    ),
                  ],
                ),
                Spacer(),
                Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        timeStamp,
                        style: TextStyle(
                          fontFamily: 'Inter',
                            fontSize: 10,
                            color: UiColors().grey,
                            //fontWeight: FontWeight.w400
                            ),
                      ),
                    ),
                    const SizedBox(width: 20,)
              ],
            ),
          ),
          MyDivider()
        ],
      ),
    );
  }
}
