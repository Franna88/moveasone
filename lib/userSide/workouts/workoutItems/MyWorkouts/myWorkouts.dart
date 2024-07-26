import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/ui/weekdaysContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({super.key});

  @override
  State<MyWorkouts> createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  var pageIndex = 0;
  List<Map<String, dynamic>> workoutDocuments = [];

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('createWorkout').get();

      List<Map<String, dynamic>> workouts = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'docId': doc.id,
          'warmupPhoto': data['warmupPhoto'] as String? ?? '',
          'selectedWeekdays': (data['selectedWeekdays'] as List<dynamic>?)
                  ?.map((day) => day.toString())
                  .join(', ') ??
              'Unknown Day',
          'bodyArea': data['bodyArea'] as String? ?? 'Unknown Workout',
        };
      }).toList();

      setState(() {
        workoutDocuments = workouts;
      });
    } catch (e) {
      print("Error fetching workouts: $e");
    }
  }

  void changePageIndex(value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'MY WORKOUTS'),
        const SizedBox(
          height: 25,
        ),
        Visibility(
          visible: pageIndex == 0,
          child: WeekdaysContainer(
              changePageIndex: changePageIndex,
              workoutDocuments: workoutDocuments),
        ),
        Visibility(
          visible: pageIndex == 1,
          child: DefaultWorkoutDetails(
            docId: '',
            userType: '',
          ),
        ),
      ],
    );
  }
}
