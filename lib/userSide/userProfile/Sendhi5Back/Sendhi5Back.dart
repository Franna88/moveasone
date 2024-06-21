import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/UserProfile/LastWorkout/LastWorkout.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/Hi5LastWorkout.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/VideoImages.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/Videos.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;
import 'package:move_as_one/userSide/workoutPopups/popUpItems/awardEmojiPopUp.dart';

class Sendhi5Back extends StatefulWidget {
  const Sendhi5Back({super.key});

  @override
  State<Sendhi5Back> createState() => _Sendhi5BackState();
}

class _Sendhi5BackState extends State<Sendhi5Back> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MyUtility(context).height * 0.05,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    print('Icon button pressed!');
                  },
                  icon: Icon(Icons.keyboard_arrow_left),
                  color: Colors.black,
                  iconSize: 30.0,
                ),
                Center(
                  child: Text(
                    'SEND HI-FIVE',
                    style: TextStyle(
                      color: consts.textcolor,
                      fontSize: 15,
                      fontFamily: 'BeVietnam',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MyUtility(context).height * 0.01,
            ),
            SizedBox(
              width: MyUtility(context).width / 1.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MyUtility(context).width * 0.05,
                  ),
                  ClipOval(
                    child: Image.asset(
                      'images/Avatar2.jpg',
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXERCISES',
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '103',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HIGH FIVE’S',
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '48',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 20),
              child: SizedBox(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Anika Mango ',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontFamily: 'Be Vietnam',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '@anikko_334',
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 16,
                          fontFamily: 'Be Vietnam',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 20),
              child: SizedBox(
                width: 311,
                child: Text(
                  "I love pizza more than fitness 🍕😋",
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 15,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AwardEmojiPopUp()),
                  );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF),
                      foregroundColor: Color(0xFF006261),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 17.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Color(0xFF006261),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      'Hi-Five',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Be Vietnam',
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF),
                      foregroundColor: Color(0xFF006261),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 17.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Color(0xFF006261),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text(
                          'Send message',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Be Vietnam',
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(0xFF1E1E1E),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.02,
            ),
            Videos(),
            Hi5LastWorkout()
          ],
        ),
      ),
    );
  }
}
