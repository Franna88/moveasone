import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkoutComponents/ReuseableContainer.dart';
import 'package:move_as_one/myutility.dart';

class YourWorkouts extends StatefulWidget {
  const YourWorkouts({super.key});

  @override
  State<YourWorkouts> createState() => _YourWorkoutsState();
}

class _YourWorkoutsState extends State<YourWorkouts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.4,
      child: Column(
        children: [
          SizedBox(
            height: MyUtility(context).height * 0.04,
          ),
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Workouts',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontFamily: 'belight',
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFFAA5F3A),
                    fontSize: 15,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w100,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: MyUtility(context).width * 0.02,
                ),
                ReuseableContainer(
                    image: 'images/mondays.png',
                    day: "Monday's",
                    workout: "Upper Body"),
                ReuseableContainer(
                    image: 'images/avatar2.png',
                    day: "Monday's",
                    workout: "Upper Body"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
