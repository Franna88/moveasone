import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/ResueableImage.dart';
import 'package:move_as_one/userSide/Home/Motivational/MotivationalComponents/MotivationalContainer.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkoutComponents/ReuseableContainer.dart';
import 'package:move_as_one/userSide/UserProfile/LastWorkout/LastWorkoutComponents/LastWorkoutImage.dart';
import 'package:move_as_one/myutility.dart';

class LastWorkout extends StatefulWidget {
  const LastWorkout({super.key});

  @override
  State<LastWorkout> createState() => _LastWorkoutState();
}

class _LastWorkoutState extends State<LastWorkout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.3,
      child: Column(
        children: [
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last workouts',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 21,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFF006261),
                    fontSize: 16,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
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
                LastWorkoutImages(
                  image: 'images/workouts1.jpg',
                  dateandworkout: '18 March 2024 Upper Body',
                ),
                LastWorkoutImages(
                  image: 'images/legs.png',
                  dateandworkout: '21 March 2024 Legs',
                ),
                LastWorkoutImages(
                  image: 'images/core.png',
                  dateandworkout: '25 March 2024 Core',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
