import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/animatedEmoji.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/clapEmoji.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/replyEmoji.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/senderName.dart';

class ConGratulatedPopUp extends StatelessWidget {
  const ConGratulatedPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: heightDevice * 0.50,
          width: widthDevice,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(151, 0, 0, 0), BlendMode.colorBurn),
                image: AssetImage('images/commonImg.png'),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                      ClapEmoji(),
                    ],
                  ),
                ),
                Spacer(),
                //SENDERS NAME
                SenderName(senderName: 'Anika Mango'),
                Text(
                  'Just Congratulated you',
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: heightDevice * 0.06,
                ),
                Center(
                  child: ReplyEmoji(
                    replyText: 'Reply Thank you',
                    emojiImage: 'images/thankYou.png',
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
