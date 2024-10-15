import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';

import '../../../commonUi/navVideoButton.dart';
import '../../../commonUi/uiColors.dart';

class DoneScreen extends StatefulWidget {
  final Map entireExercise;
  const DoneScreen({super.key, required this.entireExercise});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  Future<void> _updateUserExercises() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      // Format the current date to only include day, month, and year
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      await userDoc.update({
        'userExercises': FieldValue.arrayUnion([
          {
            'date': formattedDate, // Use the formatted date string
            'type': widget.entireExercise['bodyArea'],
            'displayImage': widget.entireExercise['displayImage']
          }
        ])
      });
      print('Workout updated successfully');
    } catch (e) {
      print('Error updating workout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Material(
        child: Stack(children: [
      Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/placeHolder1.jpg'),
              fit: BoxFit.fitHeight),
        ),
      ),
      Container(
        color: Colors.black.withOpacity(0.5),
        height: heightDevice,
        width: widthDevice,
      ),
      Container(
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'Well done!',
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Exercise Complete',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: heightDevice * 0.40,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavVideoButton(
                    buttonColor: UiColors().brown,
                    buttonText: 'Finish Workout',
                    onTap: () async {
                      await _updateUserExercises();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]));
  }
}
