import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/InfoQuiz/PhysicalLevel/PhysicalLevel.dart';

class Weight extends StatefulWidget {
  const Weight({Key? key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  late int selectedWeightIndex; // Initialize with a default value
  late bool isKgSelected; // Indicates whether kg or lbs is selected

  // Define your array of weights in kg
  final List<int> weightsKg = List.generate(
      251, (index) => index); // Adjusted the size to allow up to 150 kg
  // Define the conversion factor from kg to lbs
  final double kgToLbs = 2.20462;

  @override
  void initState() {
    super.initState();
    // Set the initial selectedWeightIndex to the index closest to the center of the list
    selectedWeightIndex = (weightsKg.length ~/ 2);
    // Initially, kg is selected
    isKgSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            ProgressBar(currentPage: 4),
            SizedBox(height: MyUtility(context).height * 0.01),
            PageIndicator(currentPage: 4),
            SizedBox(height: MyUtility(context).height * 0.05),
            Text(
              "What is your weight?",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isKgSelected = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isKgSelected
                            ? Color(0xFF006261)
                            : Color(0xFFACACAC),
                        width: 1,
                      ),
                      color:
                          isKgSelected ? Color(0x4C006261) : Colors.transparent,
                    ),
                    child: Text(
                      'Kg',
                      style: TextStyle(
                        color: isKgSelected
                            ? Color(0xFF006261)
                            : Color(0xFF1E1E1E),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isKgSelected = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isKgSelected
                            ? Color(0xFFACACAC)
                            : Color(0xFF006261),
                        width: 1,
                      ),
                      color:
                          isKgSelected ? Colors.transparent : Color(0x4C006261),
                    ),
                    child: Text(
                      'lbs',
                      style: TextStyle(
                        color: isKgSelected
                            ? Color(0xFF1E1E1E)
                            : Color(0xFF006261),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MyUtility(context).height * 0.1,
            ),
            Text(
              "${isKgSelected ? weightsKg[selectedWeightIndex] : (weightsKg[selectedWeightIndex] * kgToLbs).toStringAsFixed(2)} ${isKgSelected ? 'kg' : 'lbs'}",
              style: TextStyle(color: Colors.black, fontSize: 48),
            ),
            SizedBox(height: MyUtility(context).height * 0.01),
            // Horizontal FlatList for weight selection
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  final index = (notification.metrics.pixels / 11)
                      .round(); // Assuming each weight item is 60 pixels wide
                  setState(() {
                    selectedWeightIndex = index.clamp(0, weightsKg.length - 1);
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                physics:
                    AlwaysScrollableScrollPhysics(), // Ensure that the scroll view is always scrollable
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(weightsKg.length, (index) {
                    final weightKg = weightsKg[index];
                    double height = 40; // Default height
                    if ((index + 1) % 5 == 0) {
                      height = 60; // Make every third bar longer
                    }
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWeightIndex = index;
                            });
                          },
                          child: Container(
                            width: 3, // Adjust width as needed
                            height: height, // Adjust height dynamically
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFF006261),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(
              height: MyUtility(context).height * 0.3,
            ),
            SizedBox(
              width: MyUtility(context).width / 1.2,
              height: MyUtility(context).height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PhysicalLevel()),
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
          ],
        ),
      ),
    );
  }
}
