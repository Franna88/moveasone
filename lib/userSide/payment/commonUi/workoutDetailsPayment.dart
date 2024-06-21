import 'package:flutter/material.dart';

class WorkoutDetailsPaymnet extends StatelessWidget {
  final String workoutName;
  final String workoutDificulty;
  final String workoutImage;

  const WorkoutDetailsPaymnet(
      {super.key,
      required this.workoutName,
      required this.workoutDificulty,
      required this.workoutImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout',
          style: TextStyle(
            fontFamily: 'Inter',
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(workoutImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workoutDificulty,
                  style: TextStyle(
                    fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  workoutName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
