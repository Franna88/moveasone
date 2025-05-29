import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/InfoQuiz/Weight/Weight.dart';
import 'package:move_as_one/commonUi/ModernGlassButton.dart';

enum HeightUnit { centimeters, feet }

class HowTall extends StatefulWidget {
  final String goal;
  final String gender;
  final String age;

  const HowTall(
      {Key? key, required this.goal, required this.gender, required this.age})
      : super(key: key);

  @override
  State<HowTall> createState() => _HowTallState();
}

class _HowTallState extends State<HowTall> {
  int selectedHeight = -1; // Initialize with an invalid value
  final scrollController = FixedExtentScrollController();

  final List<int> heightsInCm = List.generate(
      200, (index) => index + 100); // Assuming the range from 100cm to 299cm

  final List<String> heightsInFt = List.generate(12, (ftIndex) {
    return List.generate(12, (inchIndex) => "$ftIndex'${inchIndex + 1}\"")
        .join(", ");
  }).join(", ").split(", "); // Generate heights in feet and inches

  HeightUnit selectedUnit = HeightUnit.centimeters; // Default to centimeters

  void _navigateToWeight(dynamic height) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Weight(
          goal: widget.goal,
          gender: widget.gender,
          age: widget.age,
          height: height.toString(),
        ), // Pass goal, gender, age, and height to Weight screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> heights =
        selectedUnit == HeightUnit.centimeters ? heightsInCm : heightsInFt;

    return Material(
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/new_photos/IMG_5621.jpeg'),
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
                        ProgressBar(currentPage: 3),
                        SizedBox(height: MyUtility(context).height * 0.01),
                        PageIndicator(currentPage: 3),
                        SizedBox(height: MyUtility(context).height * 0.03),
                        Text(
                          "How tall are you?",
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
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedUnit = HeightUnit.centimeters;
                                });
                              },
                              child: Text(
                                'cm',
                                style: TextStyle(
                                  color: selectedUnit == HeightUnit.centimeters
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 16,
                                  fontWeight:
                                      selectedUnit == HeightUnit.centimeters
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedUnit = HeightUnit.feet;
                                });
                              },
                              child: Text(
                                'ft',
                                style: TextStyle(
                                  color: selectedUnit == HeightUnit.feet
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 16,
                                  fontWeight: selectedUnit == HeightUnit.feet
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
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
                                    selectedHeight = heights[index];
                                  });
                                }
                                return true;
                              },
                              child: ListWheelScrollView(
                                controller: scrollController,
                                physics: FixedExtentScrollPhysics(),
                                itemExtent: 60, // Adjust item extent as needed
                                diameterRatio:
                                    1.5, // Adjust diameter ratio as needed
                                children: heights
                                    .map((height) => ListTile(
                                          title: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  height.toString(),
                                                  style: TextStyle(
                                                    color:
                                                        height == selectedHeight
                                                            ? Color(0xFF1E1E1E)
                                                            : Color(0xFFADADAD),
                                                    fontSize:
                                                        height == selectedHeight
                                                            ? 50
                                                            : 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  selectedUnit ==
                                                          HeightUnit.centimeters
                                                      ? 'cm'
                                                      : 'ft',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
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
                    if (selectedHeight != -1) {
                      _navigateToWeight(selectedHeight);
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
