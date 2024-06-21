import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Age/Age.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/CustomButton.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

class Gender extends StatefulWidget {
  const Gender({Key? key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  int selectedIndex = -1;

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
            colorFilter: ColorFilter.mode(
              Color.fromARGB(200, 255, 255, 255),
              BlendMode.colorBurn,
            ),
            image: AssetImage('images/quiz2.jpg'),
            
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            ProgressBar(currentPage: 1),
            SizedBox(height: MyUtility(context).height * 0.01),
            PageIndicator(currentPage: 1),
            SizedBox(height: MyUtility(context).height * 0.05),
            Text(
              "What is your gender?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Be Vietnam',
                fontWeight: FontWeight.w300,
                height: 0.07,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Age()),
                );
              },
            ),
            CustomButton(
              text: 'Male',
              isSelected: selectedIndex == 1,
              onPressed: (bool isSelected) {
                setState(() {
                  selectedIndex = isSelected ? 1 : -1;
                });
              },
            ),
            CustomButton(
              text: 'Other',
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
