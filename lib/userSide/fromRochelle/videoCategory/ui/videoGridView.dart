import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';

class VideoGridView extends StatefulWidget {
  final Function(int) changePageIndex;
  VideoGridView({super.key, required this.changePageIndex});

  @override
  State<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<DocumentSnapshot> workoutDocuments = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('createWorkout').get();
    setState(() {
      workoutDocuments = querySnapshot.docs;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animationController,
      child: Container(
        color: Colors.white,
        height: heightDevice * 0.79,
        child: GridView.builder(
          itemCount: workoutDocuments.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            var workout = workoutDocuments[index];
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DefaultWorkoutDetails(
                        docId: workout.id,
                        userType: '',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: heightDevice * 0.10,
                  width: widthDevice * 0.10,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(workout['displayImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      builder: (context, child) => Padding(
        padding: EdgeInsets.only(top: 150 - _animationController.value * 150),
        child: child,
      ),
    );
  }
}
