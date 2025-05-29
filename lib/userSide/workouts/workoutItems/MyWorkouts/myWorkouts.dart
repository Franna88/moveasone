import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/ui/weekdaysContainer.dart';
import 'package:move_as_one/enhanced_workout_viewer/enhanced_workout_viewer.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({super.key});

  @override
  State<MyWorkouts> createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  List<Map<String, dynamic>> workoutDocuments = [];
  bool isLoading = true;
  int pageIndex = 0;

  void changePageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Future<void> fetchWorkoutsByActivityLevel() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Use the EnhancedWorkoutViewer to get workouts
      List<dynamic> fetchedWorkouts =
          await EnhancedWorkoutViewer.getWorkoutsByActivityLevel();

      if (mounted) {
        setState(() {
          workoutDocuments = List<Map<String, dynamic>>.from(fetchedWorkouts);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching workouts: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    fetchWorkoutsByActivityLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'My Workouts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Be Vietnam',
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : workoutDocuments.isEmpty
              ? Center(child: Text('No workouts found for your activity level'))
              : WeekdaysContainer(
                  changePageIndex: changePageIndex,
                  workoutDocuments: workoutDocuments,
                ),
    );
  }
}
