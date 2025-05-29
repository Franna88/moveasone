import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/PageIndicator.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/GoalComponents/ProgressBar.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/InfoQuiz/PhysicalLevel/PhysicalLevel.dart';
import 'package:move_as_one/commonUi/ModernGlassButton.dart';

class Weight extends StatefulWidget {
  final String goal;
  final String gender;
  final String age;
  final String height;

  const Weight(
      {Key? key,
      required this.goal,
      required this.gender,
      required this.age,
      required this.height})
      : super(key: key);

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  late int selectedWeightIndex; // Initialize with a default value
  late bool isKgSelected; // Indicates whether kg or lbs is selected

  final List<int> weightsKg = List.generate(251, (index) => index); // 0-250 kg
  final double kgToLbs = 2.20462;

  @override
  void initState() {
    super.initState();
    selectedWeightIndex = 0; // Start at 0 kg
    isKgSelected = true; // Initially set to kg
  }

  void _storeWeight(dynamic weight, String unit) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({"weight": "$weight $unit"});
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhysicalLevel(
            goal: widget.goal,
            gender: widget.gender,
            age: widget.age,
            height: widget.height,
            weight: weight.toString(),
            weightUnit: unit,
          ),
        ),
      );
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/new_photos/IMG_5620.jpeg'),
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
                        ProgressBar(currentPage: 4),
                        SizedBox(height: MyUtility(context).height * 0.01),
                        PageIndicator(currentPage: 4),
                        SizedBox(height: MyUtility(context).height * 0.03),
                        Text(
                          "What is your weight?",
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
                        SizedBox(height: 15),
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isKgSelected
                                        ? Color(0xFF006261)
                                        : Color(0xFFACACAC),
                                    width: 1,
                                  ),
                                  color: isKgSelected
                                      ? Color(0x4C006261)
                                      : Colors.transparent,
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isKgSelected
                                        ? Color(0xFFACACAC)
                                        : Color(0xFF006261),
                                    width: 1,
                                  ),
                                  color: isKgSelected
                                      ? Colors.transparent
                                      : Color(0x4C006261),
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
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
                    child: Text(
                      "${isKgSelected ? weightsKg[selectedWeightIndex] : (weightsKg[selectedWeightIndex] * kgToLbs).toStringAsFixed(2)} ${isKgSelected ? 'kg' : 'lbs'}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MyUtility(context).width * 0.9,
                    height: 100,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          final index =
                              (notification.metrics.pixels / 11).round();
                          setState(() {
                            selectedWeightIndex =
                                index.clamp(0, weightsKg.length - 1);
                          });
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(weightsKg.length, (index) {
                            final weightKg = weightsKg[index];
                            double height = 40;
                            if ((index + 1) % 5 == 0) {
                              height = 60;
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
                                    width: 3,
                                    height: height,
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
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: ModernGlassButton(
                  buttonText: 'Continue',
                  onTap: () {
                    final weight = isKgSelected
                        ? weightsKg[selectedWeightIndex]
                        : (weightsKg[selectedWeightIndex] * kgToLbs)
                            .toStringAsFixed(2);
                    final unit = isKgSelected ? 'kg' : 'lbs';
                    _storeWeight(weight, unit);
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
