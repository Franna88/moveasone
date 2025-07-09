import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Age/Age.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

class Gender extends StatefulWidget {
  final String goal;

  const Gender({Key? key, required this.goal});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  int selectedIndex = -1;

  void _navigateToAge(String gender) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Age(
            goal: widget.goal,
            gender: gender), // Pass both goal and gender to Age screen
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
            colorFilter: ColorFilter.mode(
              Color.fromARGB(200, 255, 255, 255),
              BlendMode.colorBurn,
            ),
            image: AssetImage('images/new_photos/IMG_5622.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
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
                      ProgressBar(currentPage: 1),
                      SizedBox(height: MyUtility(context).height * 0.01),
                      PageIndicator(currentPage: 1),
                      SizedBox(height: MyUtility(context).height * 0.05),
                      Text(
                        "What is your gender?",
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
                        text: 'Female',
                        isSelected: selectedIndex == 0,
                        onPressed: (bool isSelected) {
                          setState(() {
                            selectedIndex = isSelected ? 0 : -1;
                          });
                          if (isSelected) {
                            _navigateToAge('Female');
                          }
                        },
                      ),
                      CustomButton(
                        text: 'Male',
                        isSelected: selectedIndex == 1,
                        onPressed: (bool isSelected) {
                          setState(() {
                            selectedIndex = isSelected ? 1 : -1;
                          });
                          if (isSelected) {
                            _navigateToAge('Male');
                          }
                        },
                      ),
                      CustomButton(
                        text: 'Other',
                        isSelected: selectedIndex == 2,
                        onPressed: (bool isSelected) {
                          setState(() {
                            selectedIndex = isSelected ? 2 : -1;
                          });
                          if (isSelected) {
                            _navigateToAge('Other');
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
