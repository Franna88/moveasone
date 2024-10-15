import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/userSide/UserProfile/LastWorkout/LastWorkoutComponents/LastWorkoutImage.dart';
import 'package:move_as_one/myutility.dart';

class Lastworkoutsdisplay extends StatefulWidget {
  final String userId;

  const Lastworkoutsdisplay({super.key, required this.userId});

  @override
  State<Lastworkoutsdisplay> createState() => _LastworkoutsdisplayState();
}

class _LastworkoutsdisplayState extends State<Lastworkoutsdisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.3,
      child: Column(
        children: [
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last workouts',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 21,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFF006261),
                    fontSize: 16,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No workouts found'));
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                var workouts = userData['userExercises'] as List<dynamic>?;

                if (workouts == null || workouts.isEmpty) {
                  return Center(child: Text('No workouts found'));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: MyUtility(context).width * 0.02),
                      ...workouts.map((workout) {
                        return LastWorkoutImages(
                          image: workout['displayImage'] ?? '',
                          dateandworkout:
                              '${workout['date'] ?? 'Unknown Date'}\n${workout['type'] ?? 'Unknown Type'}',
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
