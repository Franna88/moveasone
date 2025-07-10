import 'package:flutter/material.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/userSide/UserProfile/MemberOptions/MemberOptionComponents/MemberOptionsButton.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoAdd.dart';
import 'package:move_as_one/userSide/userProfile/MemberOptions/BookingPage.dart';
import 'package:move_as_one/userSide/userProfile/MemberOptions/MealPlanRequestPage.dart';
import 'package:move_as_one/myutility.dart';

class MemberOptions extends StatefulWidget {
  const MemberOptions({super.key});

  @override
  State<MemberOptions> createState() => _MemberOptionsState();
}

class _MemberOptionsState extends State<MemberOptions> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: MyUtility(context).width / 1.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Member Options',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 21,
                      fontFamily: 'BeVietnam',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.01,
            ),
            MemberOptionsButton(
                images: 'images/memberoptions1.png',
                memberoptions: "Book a mbit",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingPage(),
                    ),
                  );
                }),
            MemberOptionsButton(
                images: 'images/memberoptions2.png',
                memberoptions: "Upload Video",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserAddVideo(),
                    ),
                  );
                }),
            MemberOptionsButton(
                images: 'images/memberoptions4.png',
                memberoptions: "Community",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavBar(initialIndex: 3)),
                  );
                }),
            MemberOptionsButton(
                images: 'images/memberoptions5.png',
                memberoptions: "Request Meal Plan",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MealPlanRequestPage(),
                    ),
                  );
                }),
            /* MemberOptionsButton(
                images: 'images/memberoptions6.png',
                memberoptions: "Settings",
                onPressed: () {}),*/
            SizedBox(
              height: MyUtility(context).height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
