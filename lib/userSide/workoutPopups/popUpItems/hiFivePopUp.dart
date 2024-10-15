import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/animatedEmoji.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/replyEmoji.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/senderName.dart';

class HiFivePopUp extends StatelessWidget {
  final String senderName;

  const HiFivePopUp({Key? key, required this.senderName}) : super(key: key);

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
              fit: BoxFit.cover,
            ),
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
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      AnimatedEmoji(),
                    ],
                  ),
                ),
                Spacer(),
                //SENDERS NAME
                SenderName(senderName: senderName),
                Text(
                  'Just gave you a Hi-Five',
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: heightDevice * 0.06,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReplyEmoji(
                        replyText: 'Reply Thank you',
                        emojiImage: 'images/thankYou.png',
                      ),
                      ReplyEmoji(
                        replyText: 'Hi-Five back',
                        emojiImage: 'images/hiFive.png',
                      )
                    ],
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
