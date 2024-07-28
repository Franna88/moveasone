import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Gender/Gender.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

class QuizThree extends StatefulWidget {
  const QuizThree({Key? key});

  @override
  State<QuizThree> createState() => _QuizThreeState();
}

class _QuizThreeState extends State<QuizThree> {
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
            ProgressBar(currentPage: 2),
            SizedBox(height: MyUtility(context).height * 0.01),
            PageIndicator(currentPage: 2),
            SizedBox(height: MyUtility(context).height * 0.05),
            Text(
              "Did you do any extra reps or weight?",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            SizedBox(height: MyUtility(context).height * 0.05),
            CustomButton(
              text: 'Yes',
              isSelected: selectedIndex == 0,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 0 : -1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Gender(
                            goal: '',
                          )),
                );
              },
            ),
            CustomButton(
              text: 'No',
              isSelected: selectedIndex == 1,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 1 : -1;
                });
              },
            ),
            CustomButton(
              text: 'I Tried but failed',
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
