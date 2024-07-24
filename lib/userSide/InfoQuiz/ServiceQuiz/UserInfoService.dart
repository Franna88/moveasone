import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoService {
  Future<void> storeUserInfo({
    required String gender,
    required int age,
    required double height,
    required double weight,
    required String activityLevel,
    required String goal,
    required BuildContext context,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // Check if the user is authenticated and exists
      if (user != null) {
        var userAccountDetails = {
          "gender": gender,
          "age": age,
          "height": height,
          "weight": weight,
          "activityLevel": activityLevel,
          "goal": goal,
        };

        // Update the user's document in Firestore with the user account details
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update(userAccountDetails)
            .whenComplete(() {
          Fluttertoast.showToast(
              msg: 'User info updated successfully!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
