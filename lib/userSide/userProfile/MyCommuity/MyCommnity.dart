import 'package:flutter/material.dart';
import 'package:move_as_one/MyHome.dart';
import 'package:move_as_one/userSide/UserProfile/MyCommuity/MyCommunityComponents/FriendsList.dart';
import 'package:move_as_one/userSide/UserProfile/MyCommuity/Other/Trainers.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;
import 'package:move_as_one/userSide/userProfile/Sendhi5Back/Sendhi5Back.dart';
import 'package:move_as_one/userSide/userProfile/UserProfile.dart';

class MyCommunity extends StatefulWidget {
  const MyCommunity({super.key});

  @override
  State<MyCommunity> createState() => _MyCommunityState();
}

class _MyCommunityState extends State<MyCommunity> {
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHome()),
                    );
                  },
                  child: Text(
                    'MY COMMUNITY',
                    style: TextStyle(
                      color: consts.textcolor,
                      fontSize: 15,
                      fontFamily: 'BeVietnam',
                      fontWeight: FontWeight.w300,
                    ),
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
                            print('Friends button tapped!');
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
                          height: 3,
                          width: MyUtility(context).width / 2.1,
                          decoration: BoxDecoration(color: Color(0xFF006261)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Trainers()),
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
                          child: Text('Other'),
                        ),
                        Container(
                          height: 1,
                          width: MyUtility(context).width / 2.1,
                          decoration: BoxDecoration(color: Color(0xFF006261)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Sendhi5Back()),
                  );
                },
                child: FriendsList(
                    picture: 'images/pfp1.jpg',
                    name: 'Dulce Bothman',
                    onPressed: () {}),
              ),
              FriendsList(
                  picture: 'images/pfp2.jpg',
                  name: 'Alfredo Westervelt',
                  onPressed: () {}),
              FriendsList(
                  picture: 'images/pfp3.jpg',
                  name: 'Chance Culhane',
                  onPressed: () {}),
              FriendsList(
                  picture: 'images/comment1.jpg',
                  name: 'Alfredo Passaquind...',
                  onPressed: () {}),
              FriendsList(
                  picture: 'images/comment2.jpg',
                  name: 'Kaylynn Korsgaard',
                  onPressed: () {}),
              FriendsList(
                  picture: 'images/comment3.jpg',
                  name: 'Madelyn Lipshutz',
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
