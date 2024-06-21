import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/InfoQuiz/Weight/Weight.dart';

enum HeightUnit { centimeters, feet }

class HowTall extends StatefulWidget {
  const HowTall({Key? key});

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

  HeightUnit selectedUnit = HeightUnit.centimeters; // Default unit

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
            image: AssetImage('images/quiz2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            ProgressBar(currentPage: 3),
            SizedBox(height: MyUtility(context).height * 0.01),
            PageIndicator(currentPage: 3),
            SizedBox(height: MyUtility(context).height * 0.05),
            Text(
              "How tall are you?",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
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
                      fontWeight: selectedUnit == HeightUnit.centimeters
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
                              selectedHeight = heights[index];
                            });
                          }
                          return true;
                        },
                        child: ListWheelScrollView(
                          controller: scrollController,
                          physics: FixedExtentScrollPhysics(),
                          itemExtent: 60, // Adjust item extent as needed
                          diameterRatio: 1.5, // Adjust diameter ratio as needed
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
                                              color: height == selectedHeight
                                                  ? Color(0xFF1E1E1E)
                                                  : Color(0xFFADADAD),
                                              fontSize: height == selectedHeight
                                                  ? 50
                                                  : 40,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            selectedUnit == HeightUnit.centimeters
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
            SizedBox(
              width: MyUtility(context).width / 1.2,
              height: MyUtility(context).height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Weight()),
                              );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF006261)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
