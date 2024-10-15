import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkoutComponents/ReuseableContainer.dart';
import 'package:move_as_one/myutility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';

class YourWorkouts extends StatefulWidget {
  const YourWorkouts({super.key});

  @override
  _YourWorkoutsState createState() => _YourWorkoutsState();
}

class _YourWorkoutsState extends State<YourWorkouts> {
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
        var data = doc.data() as Map<String, dynamic>;
        print("Fetched workout data: $data"); // Debug print
        return {
          'displayImage': data['displayImage'] as String? ?? '',
          'selectedWeekdays': (data['selectedWeekdays'] as List<dynamic>?)
                  ?.map((day) => day.toString())
                  .join(', ') ??
              'Unknown Day',
          'bodyArea': data['bodyArea'] as String? ?? 'Unknown Workout',
        };
      }).toList();

      print("Processed workouts: $workouts");

      setState(() {
        workoutDocuments = workouts;
      });
    } catch (e) {
      print("Error fetching workouts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.4,
      child: Column(
        children: [
          SizedBox(
            height: MyUtility(context).height * 0.04,
          ),
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Workouts',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontFamily: 'belight',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyWorkouts()));
                  },
                  child: Text(
                    'See more',
                    style: TextStyle(
                      color: Color(0xFFAA5F3A),
                      fontSize: 15,
                      fontFamily: 'Be Vietnam',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          workoutDocuments.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: workoutDocuments.map((workout) {
                        print(
                            'Image URL: ${workout['displayImage']}'); // Debug print
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ReuseableContainer(
                            image: workout['displayImage'] ??
                                'https://via.placeholder.com/150', // Default image URL
                            day: workout['selectedWeekdays'] ?? 'Unknown Day',
                            workout: workout['bodyArea'] ?? 'Unknown Workout',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
