import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/UserProfile/MyCommuity/MyCommnity.dart';
import 'package:move_as_one/userSide/UserProfile/MyCommuity/MyCommunityComponents/FriendsList.dart';
import 'package:move_as_one/userSide/UserProfile/MyCommuity/Other/NotFriends.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;

class Trainers extends StatefulWidget {
  const Trainers({super.key});

  @override
  State<Trainers> createState() => _TrainersState();
}

class _TrainersState extends State<Trainers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MyUtility(context).height * 0.025,
              ),
              Center(
                child: Text(
                  'TRAINERS',
                  style: TextStyle(
                    color: consts.textcolor,
                    fontSize: 15,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(
                height: MyUtility(context).height * 0.01,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyCommunity()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFF1E1E1E),
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Belight',
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          child: Text('Friends'),
                        ),
                        Container(
                          height: 1,
                          width: MyUtility(context).width / 2.1,
                          decoration: BoxDecoration(color: Color(0xFF006261)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Other button tapped!');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFF1E1E1E),
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Belight',
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          child: Text('Other'),
                        ),
                        Container(
                          height: 3,
                          width: MyUtility(context).width / 2.1,
                          decoration: BoxDecoration(color: Color(0xFF006261)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              NotFriends(
                  picture: 'images/Avatar2.jpg',
                  name: "Anika Mango",
                  onPressed: () {}),
              NotFriends(
                  picture: 'images/comment3.jpg',
                  name: "Cristofer Ekstrom",
                  onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
