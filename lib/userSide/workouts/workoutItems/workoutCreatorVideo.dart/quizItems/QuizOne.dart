import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/QuizTwo.dart';

class QuizOne extends StatefulWidget {
  const QuizOne({Key? key});

  @override
  State<QuizOne> createState() => _QuizOneState();
}

class _QuizOneState extends State<QuizOne> {
  int selectedIndex = -1; // Initially no button is selected

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/strech.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            ProgressBar(currentPage: 0),
            SizedBox(height: MyUtility(context).height * 0.01),
            PageIndicator(currentPage: 0),
            SizedBox(height: MyUtility(context).height * 0.05),
            Text(
              "How did you feel while Excersising?",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            SizedBox(height: MyUtility(context).height * 0.05),
            CustomButton(
              text: 'Good',
              isSelected: selectedIndex == 0,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 0 : -1;
                });
                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QuizTwo()),
                              );
              },
            ),
            CustomButton(
              text: 'Bad',
              isSelected: selectedIndex == 1,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 1 : -1;
                });
              },
            ),
            CustomButton(
              text: 'Tired',
              isSelected: selectedIndex == 2,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 2 : -1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
