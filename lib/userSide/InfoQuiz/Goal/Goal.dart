import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Gender/Gender.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

class Goal extends StatefulWidget {
  const Goal({Key? key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
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
            image: AssetImage('images/quiz1.png'),
            fit: BoxFit.cover,
            alignment: Alignment(0.4, 1)
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
              "What is your primary goal?",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            SizedBox(height: MyUtility(context).height * 0.05),
            CustomButton(
              text: 'Lose weight',
              isSelected: selectedIndex == 0,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 0 : -1;
                });
                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Gender()),
                              );
              },
            ),
            CustomButton(
              text: 'Build muscle',
              isSelected: selectedIndex == 1,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 1 : -1;
                });
              },
            ),
            CustomButton(
              text: 'Keep fit',
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
