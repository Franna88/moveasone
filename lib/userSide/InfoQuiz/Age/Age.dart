import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/commonUi/ModernGlassButton.dart';

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
            image: AssetImage('images/new_photos/IMG_5623.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MyUtility(context).height * 0.05),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MyUtility(context).width * 0.9,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        ProgressBar(currentPage: 2),
                        SizedBox(height: MyUtility(context).height * 0.01),
                        PageIndicator(currentPage: 2),
                        SizedBox(height: MyUtility(context).height * 0.05),
                        Text(
                          "How old are you?",
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
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MyUtility(context).width * 0.7,
                        height: MyUtility(context).height * 0.4,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: MyUtility(context).height * 0.13,
                              left: 20,
                              right: 20,
                              child: Container(
                                height: 3,
                                color: UiColors().teal,
                              ),
                            ),
                            Positioned(
                              bottom: MyUtility(context).height * 0.095,
                              left: 20,
                              right: 20,
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
                                                fontSize: age == selectedAge
                                                    ? 50
                                                    : 40,
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
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: ModernGlassButton(
                  buttonText: 'Continue',
                  onTap: () {
                    if (selectedAge != -1) {
                      _navigateToHowTall(selectedAge);
                    }
                  },
                  buttonColor: Color(0xFF006261),
                  width: MyUtility(context).width * 0.9,
                  borderRadius: 30,
                  height: MyUtility(context).height * 0.06,
                  backgroundOpacity: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
