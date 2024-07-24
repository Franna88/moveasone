import 'package:flutter/material.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/ui/weekdaysContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({super.key});

  @override
  State<MyWorkouts> createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  var pageIndex = 0;

  changePageIndex(value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'MY WORKOUTS'),
        const SizedBox(
          height: 25,
        ),
        Visibility(
          visible: pageIndex == 0 ? true : false,
          child: WeekdaysContainer(
            changePageIndex: changePageIndex,
          ),
        ),
        Visibility(
          visible: pageIndex == 1 ? true : false,
          child: DefaultWorkoutDetails(
            docId: '',
          ),
        ),
        //SizedBox(height: 100, child: BottomNavBar(),)
      ],
    );
  }
}
