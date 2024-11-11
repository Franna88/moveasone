import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:move_as_one/userSide/UserProfile/MemberOptions/MemberOption.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/settingsMain.dart';
import 'package:move_as_one/userSide/userProfile/LastWorkout/LastWorkout.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/editProfileMain.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/myProgressMain.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = '';
  String bio = '';
  String website = '';
  String profilePicUrl = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        userId = uid;
        name = doc.get('name');
        bio = doc.get('bio');
        website = doc.get('website');
        profilePicUrl = doc.get('profilePic');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MyUtility(context).height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*Align(
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
                      ),*/
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsMain()),
                          );
                        },
                        child: Icon(
                          Icons.settings_outlined,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MyUtility(context).width * 0.05,
                      ),
                      profilePicUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                profilePicUrl,
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                            ),
                      SizedBox(width: 10),
                      Column(
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
                            '24',
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 17,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
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
                            '17',
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 17,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileMain()),
                            );
                          },
                          child: SvgPicture.asset(
                            'images/Edit.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, left: 20),
                  child: SizedBox(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 18,
                              fontFamily: 'Be Vietnam',
                              fontWeight: FontWeight.w600,
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
                            text: '@lanasteps',
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
                      bio,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 17,
                        fontFamily: 'Be Vietnam',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    child: Text(
                      website,
                      style: TextStyle(
                        color: Color(0xFF006261),
                        fontSize: 14,
                        fontFamily: 'Be Vietnam',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: MyUtility(context).width / 1.125,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MyUtility(context).width / 2.2,
                          height: MyUtility(context).height * 0.07,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 19),
                          decoration: ShapeDecoration(
                            color: Color(0xFFAA5F3A),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFF1E1E1E)),
                              borderRadius: BorderRadius.circular(64),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Message Rachelle',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Be Vietnam',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            'images/notification.svg',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyProgressMain()),
                            );
                          },
                          child: SvgPicture.asset(
                            'images/settingline.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.05,
                ),
                LastWorkout(
                  userId: userId,
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.01,
                ),
                MemberOptions()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
