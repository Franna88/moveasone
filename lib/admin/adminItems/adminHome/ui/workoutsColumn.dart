import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationAdd.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/columnHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/checkInQuestions.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryMain.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/videoBrowsPage.dart';

class WorkoutsColumn extends StatefulWidget {
  const WorkoutsColumn({super.key});

  @override
  State<WorkoutsColumn> createState() => _WorkoutsColumnState();
}

class _WorkoutsColumnState extends State<WorkoutsColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnHeader(header: 'Workouts'),
          CommonButtons(
              buttonText: 'New Workout',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkoutCategoryMain()),
                );
                //ADD LOGIC HERE
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: 'All Workouts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoBrowsPage()),
                );
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: 'Check In Questions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CheckInQuestions()),
                );
                //ADD LOGIC HERE
              },
              buttonColor: AdminColors().lightTeal),
          ColumnHeader(header: 'Motivation'),
          CommonButtons(
              buttonText: 'Add Motivation',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => /*VideoBrowsPage()*/
                          MotivationAdd()),
                );
              },
              buttonColor: AdminColors().lightTeal),
        ],
      ),
    );
  }
}
