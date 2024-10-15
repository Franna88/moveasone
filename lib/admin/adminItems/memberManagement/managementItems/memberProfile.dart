import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_as_one/admin/adminItems/bookings/chat/myChat.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProgress.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/profileAbout.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/MylinearProgressBar.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/bioButton.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/memberProfileDataCon.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/statusBarActivity.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/statusIndicator.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/workoutStatusWidget.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/UserProfile/LastWorkout/LastWorkout.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/settingsMain.dart';
import 'package:move_as_one/userSide/userProfile/LastWorkout/LastWorkout.dart';
import 'package:move_as_one/userSide/userProfile/LastWorkout/LastWorkoutComponents/LastworkoutsDisplay.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/mainContentContainer.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/editProfileMain.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/myProgressMain.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/statusPaymentBar.dart';

class MemberProfile extends StatelessWidget {
  final String memberName;
  final String memberImage;
  final String memberBio;
  final String memberWebsite;
  final String userId; // Add userId as a parameter to fetch specific user data

  const MemberProfile({
    super.key,
    required this.memberName,
    required this.memberImage,
    required this.memberBio,
    required this.memberWebsite,
    required this.userId,
  });

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileAbout()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: memberImage.isNotEmpty
                              ? NetworkImage(memberImage)
                              : AssetImage('images/avatar1.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FOLLOWERS',
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
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FOLLOWINGS',
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
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '30%',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'BEGINNER',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF6F6F6F),
                                      fontSize: 10,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                      letterSpacing: 0.50,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              MyLinearProgressBar(
                                  barColor: Color(0xFF0043CE),
                                  barValue: 0.30,
                                  backgroundColor: Color(0xFFE0E0E0),
                                  width: 0.55),
                            ],
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
                            text: memberName,
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
                      memberBio,
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
                      memberWebsite,
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
                BioButton(),
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
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFF1E1E1E)),
                              borderRadius: BorderRadius.circular(64),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyChat(
                                    userId: userId,
                                    userName: memberName,
                                    userPic: memberImage,
                                    chatId: '',
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'Message',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
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
                                builder: (context) =>
                                    const MemberProgressMain(),
                              ),
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: MemberProfileDatCon(
                    child: Lastworkoutsdisplay(
                      userId: userId,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 20),
                  child: MemberProfileDatCon(
                    child: Column(
                      children: [
                        StatusIndicator(
                          barType: StatusBarActivity(percentage: 80),
                          progressType: 'Positive',
                          textColor: Color(0xFF006261),
                        ),
                        StatusIndicator(
                          barType: SatusPaymentBar(
                            currentStep: 3,
                          ),
                          progressType: 'Payment',
                          textColor: Color(0xFFDA1E28),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WorkoutStatusWidget(
                              action: 'Workouts Done',
                              iconColor: Color(0xFF0043CE),
                              progressBarr: MyLinearProgressBar(
                                  barColor: Color.fromARGB(255, 4, 212, 11),
                                  barValue: 1,
                                  backgroundColor: Colors.green,
                                  width: 0.10),
                            ),
                            WorkoutStatusWidget(
                              action: 'Skipped',
                              iconColor: Color(0xFF0043CE),
                              progressBarr: MyLinearProgressBar(
                                  barColor: Color(0xFF0043CE),
                                  barValue: 1,
                                  backgroundColor:
                                      Color.fromARGB(117, 0, 69, 206),
                                  width: 0.45),
                            ),
                            WorkoutStatusWidget(
                              action: 'Not Completed',
                              iconColor: Color(0xFFF1C21B),
                              progressBarr: MyLinearProgressBar(
                                  barColor: Color(0xFFF1C21B),
                                  barValue: 0.60,
                                  backgroundColor:
                                      Color.fromARGB(127, 241, 195, 27),
                                  width: 0.10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Center(
                  child: Container(
                    width: 161,
                    height: 49,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF006261),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Watch Member',
                          style: TextStyle(
                            color: Color(0xFF006261),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
