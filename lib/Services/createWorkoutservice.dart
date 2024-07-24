import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addWorkoutCategory(
    String categoryName, String workoutImage) async {
  CollectionReference workoutCategories =
      FirebaseFirestore.instance.collection('createWorkout');
  await workoutCategories.add({
    'categoryName': categoryName,
    'workoutImage': workoutImage,
  });
}
