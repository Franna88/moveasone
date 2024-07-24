import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Analysed/Analysed.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

class PhysicalLevel extends StatefulWidget {
  const PhysicalLevel({Key? key});

  @override
  State<PhysicalLevel> createState() => _PhysicalLevelState();
}

class _PhysicalLevelState extends State<PhysicalLevel> {
  int selectedIndex = -1;

  final email = TextEditingController();
  final password = TextEditingController();

  void _storeactivityLevel(String activityLevel) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({"activityLevel": activityLevel});
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Analysed()),
      );
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/quiz2.jpg'),
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MyUtility(context).height * 0.05),
            CustomButton(
              text: 'Rookie',
              isSelected: selectedIndex == 0,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 0 : -1;
                });
                if (isSelected) {
                  _storeactivityLevel('Rookie');
                }
              },
            ),
            CustomButton(
              text: 'Beginner',
              isSelected: selectedIndex == 1,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 1 : -1;
                });
                if (isSelected) {
                  _storeactivityLevel('Beginner');
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
                  _storeactivityLevel('Intermediate');
                }
              },
            ),
            CustomButton(
              text: 'Advance',
              isSelected: selectedIndex == 3,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 3 : -1;
                });
                if (isSelected) {
                  _storeactivityLevel('Advance');
                }
              },
            ),
            CustomButton(
              text: 'Ultimate',
              isSelected: selectedIndex == 4,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 4 : -1;
                });
                if (isSelected) {
                  _storeactivityLevel('Ultimate');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
