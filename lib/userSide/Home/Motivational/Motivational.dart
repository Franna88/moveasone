import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/ResueableImage.dart';
import 'package:move_as_one/userSide/Home/Motivational/MotivationalComponents/MotivationalContainer.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkoutComponents/ReuseableContainer.dart';
import 'package:move_as_one/myutility.dart';

class Motivational extends StatefulWidget {
  const Motivational({super.key});

  @override
  State<Motivational> createState() => _MotivationalState();
}

class _MotivationalState extends State<Motivational> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.35,
      child: Column(
        children: [
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Motivational',
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
                MotivationalContainer(
                  image: 'images/youJoy.png',
                  motivational: "Your Joy",
                  color: Colors.white,
                ),
                MotivationalContainer(
                  image: 'images/innerPeace.png',
                  motivational: "Inner Peace",
                  color: Colors.black,
                ),
                MotivationalContainer(
                  image: 'images/joy.png',
                  motivational: "Weight loss\nTraining",
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
