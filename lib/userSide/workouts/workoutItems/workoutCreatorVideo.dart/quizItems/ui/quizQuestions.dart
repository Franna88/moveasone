import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/questionModel/questionModel.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/ui/quizButton.dart';

class QuizQuestions extends StatelessWidget {
  Function() nextPage;
  QuizQuestions({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.60,
      width: widthDevice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            questions[0].question,
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          const SizedBox(
            height: 30,
          ),
          QuizButton(answer: questions[0].answers[0], onTap: nextPage()),
          QuizButton(
            answer: questions[1].answers[1],
            onTap: nextPage,
          ),
          QuizButton(
            answer: questions[2].answers[2],
            onTap: nextPage,
          ),
        ],
      ),
    );
  }
}
