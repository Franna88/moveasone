import 'dart:ui';
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
  int selectedIndex = -1;

  void _navigateToGender(String goal) {
    // Navigate to the Gender screen and pass the goal data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Gender(goal: goal), // Pass the goal to Gender screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/new_photos/IMG_5624.jpeg'),
            fit: BoxFit.cover,
            alignment: Alignment(0.4, 1),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MyUtility(context).width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProgressBar(currentPage: 0),
                      SizedBox(height: MyUtility(context).height * 0.01),
                      PageIndicator(currentPage: 0),
                      SizedBox(height: MyUtility(context).height * 0.05),
                      Text(
                        "What is your primary goal?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MyUtility(context).height * 0.05),
                      CustomButton(
                        text: 'Lose weight',
                        isSelected: selectedIndex == 0,
                        onPressed: (bool isSelected) {
                          setState(() {
                            selectedIndex = isSelected ? 0 : -1;
                          });
                          if (isSelected) {
                            _navigateToGender('Lose weight');
                          }
                        },
                      ),
                      CustomButton(
                        text: 'Build muscle',
                        isSelected: selectedIndex == 1,
                        onPressed: (bool isSelected) {
                          setState(() {
                            selectedIndex = isSelected ? 1 : -1;
                          });
                          if (isSelected) {
                            _navigateToGender('Build muscle');
                          }
                        },
                      ),
                      CustomButton(
                        text: 'Keep fit',
                        isSelected: selectedIndex == 2,
                        onPressed: (bool isSelected) {
                          setState(() {
                            selectedIndex = isSelected ? 2 : -1;
                          });
                          if (isSelected) {
                            _navigateToGender('Keep fit');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
