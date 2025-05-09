import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';

import 'package:move_as_one/userSide/InfoQuiz/HowTall/HowTall.dart'; // Import HowTall screen

class Age extends StatefulWidget {
  final String goal;
  final String gender;

  const Age({Key? key, required this.goal, required this.gender});

  @override
  State<Age> createState() => _AgeState();
}

class _AgeState extends State<Age> {
  int selectedAge = 15; // Set the default selected age to 15
  final scrollController =
      FixedExtentScrollController(initialItem: 14); // Set initialItem to 14
  final List<int> ages = List.generate(100, (index) => index + 1);

  void _navigateToHowTall(int age) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HowTall(
          goal: widget.goal,
          gender: widget.gender,
          age: age.toString(),
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
            image: AssetImage('images/startImage.png'),
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
              "How old are you?",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: MyUtility(context).width * 0.5,
                  height: MyUtility(context).height * 0.3,
                  child: Stack(
                    children: [
                      Positioned(
                        top: MyUtility(context).height * 0.13,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          color: UiColors().teal,
                        ),
                      ),
                      Positioned(
                        bottom: MyUtility(context).height * 0.095,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          color: UiColors().teal,
                        ),
                      ),
                      NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            final index = scrollController.selectedItem;
                            setState(() {
                              selectedAge = ages[index];
                            });
                          }
                          return true;
                        },
                        child: ListWheelScrollView(
                          controller: scrollController,
                          physics: FixedExtentScrollPhysics(),
                          itemExtent: 60,
                          diameterRatio: 1.5,
                          children: ages
                              .map((age) => ListTile(
                                    title: Center(
                                      child: Text(
                                        age.toString(),
                                        style: TextStyle(
                                          color: age == selectedAge
                                              ? Color(0xFF1E1E1E)
                                              : Color(0xFFADADAD),
                                          fontSize:
                                              age == selectedAge ? 50 : 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MyUtility(context).width / 1.2,
              height: MyUtility(context).height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedAge != -1) {
                    _navigateToHowTall(selectedAge);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Color(0xFF006261)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.05,
            )
          ],
        ),
      ),
    );
  }
}
