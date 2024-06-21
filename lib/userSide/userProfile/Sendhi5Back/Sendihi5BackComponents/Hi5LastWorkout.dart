import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/VideoImages.dart';
import 'package:move_as_one/myutility.dart';

class Hi5LastWorkout extends StatefulWidget {
  const Hi5LastWorkout({super.key});

  @override
  State<Hi5LastWorkout> createState() => _Hi5LastWorkoutState();
}

class _Hi5LastWorkoutState extends State<Hi5LastWorkout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'last Workout',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 20,
                  fontFamily: 'Belight',
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFF0085FF), // Text color
                    fontSize: 15,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: MyUtility(context).width * 0.02,
              ),
              VideoImages(image: 'images/workouts1.jpg'),
              VideoImages(image: 'images/legs.png'),
              VideoImages(image: 'images/core.png'),
            ],
          ),
        ),
      ],
    );
  }
}
