import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class BookingUserItem extends StatelessWidget {
  final String userPic;
  final String userName;
  final String bookingDate;
  final String timeStamp;
  const BookingUserItem(
      {super.key,
      required this.userPic,
      required this.userName,
      required this.bookingDate,
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
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    
                    Text(
                      bookingDate,
                      style: TextStyle(
                          fontSize: 14,
                          color: UiColors().textgrey,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Spacer(),
                Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        timeStamp,
                        style: TextStyle(
                            fontSize: 12,
                            color: UiColors().grey,
                            fontWeight: FontWeight.w400),
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
