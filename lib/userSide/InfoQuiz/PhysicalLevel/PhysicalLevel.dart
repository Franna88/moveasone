import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Analysed/Analysed.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

class PhysicalLevel extends StatefulWidget {
  final String goal;
  final String gender;
  final String height;
  final String weight;
  final String weightUnit;
  final String age;

  const PhysicalLevel({
    Key? key,
    required this.goal,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.weightUnit,
  }) : super(key: key);

  @override
  State<PhysicalLevel> createState() => _PhysicalLevelState();
}

class _PhysicalLevelState extends State<PhysicalLevel> {
  int selectedIndex = -1;

  void _storeActivityLevel(String activityLevel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Analysed(
          goal: widget.goal,
          gender: widget.gender,
          height: widget.height,
          weight: widget.weight,
          weightUnit: widget.weightUnit,
          activityLevel: activityLevel,
          age: widget.age,
        ),
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
            image: AssetImage('images/memberoptions6.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            ProgressBar(currentPage: 5),
            SizedBox(height: MyUtility(context).height * 0.01),
            PageIndicator(currentPage: 5),
            SizedBox(height: MyUtility(context).height * 0.05),
            SizedBox(
              width: MyUtility(context).width / 1.6,
              child: Text(
                "Your regular physical activity level?",
                style: TextStyle(color: Colors.black, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MyUtility(context).height * 0.05),
            /*CustomButton(
              text: 'Rookie',
              isSelected: selectedIndex == 0,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 0 : -1;
                });
                if (isSelected) {
                  _storeActivityLevel('Rookie');
                }
              },
            ),*/
            CustomButton(
              text: 'Beginner',
              isSelected: selectedIndex == 1,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 1 : -1;
                });
                if (isSelected) {
                  _storeActivityLevel('Beginner');
                }
              },
            ),
            CustomButton(
              text: 'Intermediate',
              isSelected: selectedIndex == 2,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 2 : -1;
                });
                if (isSelected) {
                  _storeActivityLevel('Intermediate');
                }
              },
            ),
            CustomButton(
              text: 'Advanced',
              isSelected: selectedIndex == 3,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 3 : -1;
                });
                if (isSelected) {
                  _storeActivityLevel('Advanced');
                }
              },
            ),
            /*CustomButton(
              text: 'Ultimate',
              isSelected: selectedIndex == 4,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 4 : -1;
                });
                if (isSelected) {
                  _storeActivityLevel('Ultimate');
                }
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
