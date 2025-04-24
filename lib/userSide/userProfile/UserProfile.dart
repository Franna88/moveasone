import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';

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
  Directory? dir;
  File? savedFile;
  bool loading = false;
  String errorMessage = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String profileImageUrl = '';
  String photoUrl = '';
  bool hasImage = false;
  int motivationScore = 0;
  int daysSinceLastWorkout = 0;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          setState(() {
            firstName = userData['firstName'] ?? '';
            lastName = userData['lastName'] ?? '';
            email = userData['email'] ?? '';
            profileImageUrl = userData['profileImage'] ?? '';
            motivationScore =
                userData['motivationScore'] ?? 75; // Default value if not set

            // Calculate days since last workout
            if (userData['lastWorkoutDate'] != null) {
              DateTime lastWorkout =
                  (userData['lastWorkoutDate'] as Timestamp).toDate();
              daysSinceLastWorkout =
                  DateTime.now().difference(lastWorkout).inDays;
            } else {
              daysSinceLastWorkout = 7; // Default value if not set
            }
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Color getMotivationColor() {
    if (motivationScore >= 80) {
      return Color(0xFF4CAF50); // Green for high motivation
    } else if (motivationScore >= 50) {
      return Color(0xFFFFA726); // Orange for medium motivation
    } else {
      return Color(0xFFE57373); // Red for low motivation
    }
  }

  String getMotivationStatus() {
    if (motivationScore >= 80) {
      return "HIGH FIVE'S - KEEP IT UP!";
    } else if (motivationScore >= 50) {
      return "DOING GOOD - STAY FOCUSED!";
    } else {
      return "LET'S GET MOVING AGAIN!";
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
                      profileImageUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                profileImageUrl,
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
                            "HIGH FIVE'S",
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
                            text: firstName,
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
                      lastName,
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
                      email,
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
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.01,
                ),
                MemberOptions(),
                // Motivation Score Container
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Motivation Score',
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 16,
                                fontFamily: 'Be Vietnam',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: getMotivationColor(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$motivationScore%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Be Vietnam',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getMotivationStatus(),
                              style: TextStyle(
                                color: getMotivationColor(),
                                fontSize: 14,
                                fontFamily: 'Be Vietnam',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              daysSinceLastWorkout == 0
                                  ? 'Worked out today'
                                  : daysSinceLastWorkout == 1
                                      ? 'Last workout: yesterday'
                                      : 'Last workout: $daysSinceLastWorkout days ago',
                              style: TextStyle(
                                color: Color(0xFF6F6F6F),
                                fontSize: 12,
                                fontFamily: 'Be Vietnam',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
