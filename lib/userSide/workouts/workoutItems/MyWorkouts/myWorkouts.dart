import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String userActivityLevel = '';

  @override
  void initState() {
    super.initState();
    fetchUserActivityLevel();
  }

  Future<void> fetchUserActivityLevel() async {
    try {
      // Get the currently logged-in user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch the user's activity level from Firestore
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid) // Use the current user's ID
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          userActivityLevel = userData['activityLevel'] as String? ?? '';

          // Fetch workouts after getting the user's activity level
          await fetchWorkouts();
        } else {
          print("User document does not exist.");
        }
      } else {
        print("No user is currently logged in.");
      }
    } catch (e) {
      print("Error fetching user activity level: $e");
    }
  }

  Future<void> fetchWorkouts() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('createWorkout')
          .where('difficulty', isEqualTo: userActivityLevel)
          .get();

      List<Map<String, dynamic>> workouts = querySnapshot.docs.map((doc) {
        var data = doc.data();
        print('Fetched workout data: $data'); // Debug print
        return {
          'docId': doc.id,
          'displayImage': data['displayImage'] as String? ?? '',
          'selectedWeekdays': (data['selectedWeekdays'] as List<dynamic>?)
                  ?.map((day) => day.toString())
                  .join(', ') ??
              'Unknown Day',
          'bodyArea': data['bodyArea'] as String? ?? 'Unknown Workout',
        };
      }).toList();

      print('Processed workouts: $workouts'); // Debug print

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
    return SafeArea(
      child: MainContainer(
        children: [
          HeaderWidget(
            header: 'MY WORKOUTS',
          ),
          const SizedBox(
            height: 25,
          ),
          Visibility(
            visible: pageIndex == 0,
            child: WeekdaysContainer(
              changePageIndex: changePageIndex,
              workoutDocuments: workoutDocuments,
            ),
          ),
          Visibility(
            visible: pageIndex == 1,
            child: DefaultWorkoutDetails(
              docId: workoutDocuments.isNotEmpty
                  ? workoutDocuments[0]['docId']
                  : '',
              userType: 'user',
            ),
          ),
        ],
      ),
    );
  }
}
