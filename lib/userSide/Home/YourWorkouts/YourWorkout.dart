import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkoutComponents/ReuseableContainer.dart';
import 'package:move_as_one/myutility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/ui/weekdaysContainer.dart';

class YourWorkouts extends StatefulWidget {
  const YourWorkouts({super.key});

  @override
  _YourWorkoutsState createState() => _YourWorkoutsState();
}

class _YourWorkoutsState extends State<YourWorkouts> {
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
          'warmupPhoto': data['warmupPhoto'] as String? ??
              '', // Provide an empty string if null
          'selectedWeekdays': (data['selectedWeekdays'] as List<dynamic>?)
                  ?.map((day) => day.toString())
                  .join(', ') ??
              'Unknown Day', // Convert list to string
          'bodyArea': data['bodyArea'] as String? ??
              'Unknown Workout', // Provide a default workout
        };
      }).toList();

      // Print the fetched workout documents for debugging
      print(workouts);

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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ReuseableContainer(
                            image: workout['warmupPhoto'],
                            day: workout['selectedWeekdays'],
                            workout: workout['bodyArea'],
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
