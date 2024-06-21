import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class ExercisesAmount extends StatelessWidget {
  final String amountOfExercises;
  const ExercisesAmount({super.key, required this.amountOfExercises});

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXERCISES',
                  style: TextStyle(
                    fontFamily: 'Inter',
                      fontSize: 11,
                      color: UiColors().textgrey,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 2,),
                Text(
                  amountOfExercises,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            );
  }
}