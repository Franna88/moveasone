import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class TopChatCon extends StatelessWidget {
  final String userName;
  final String userPic;
  final String activityStatus;
  const TopChatCon(
      {super.key,
      required this.userName,
      required this.userPic,
      required this.activityStatus});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      width: widthDevice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: widthDevice * 0.18,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 22,
                  backgroundImage: NetworkImage(userPic),
                ),
                const SizedBox(
                  width: 10,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        userName,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        activityStatus,
                        style: TextStyle(
                            fontSize: 14,
                            color: UiColors().textgrey,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.2,
            width: widthDevice,
            color: Color.fromARGB(255, 128, 126, 126),
          ),
        ],
      ),
    );
  }
}
