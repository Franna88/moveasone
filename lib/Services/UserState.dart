import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/HomePage.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';

class UserState extends StatefulWidget {
  const UserState({super.key});

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  String userType = "";
  bool isLoading = true; // To indicate loading state

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  void _checkUserType() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      if (data != null && data['status'] != null) {
        setState(() {
          userType = data['status'];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _onWillPop() async {
    // Define default navigation logic for the back button
    if (userType == "user") {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WorkoutsFullLenght()),
        (Route<dynamic> route) => false,
      );
    }
    return false; // Prevents default pop behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting ||
              isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (userSnapshot.hasData) {
            if (userType == "user") {
              return Material(child: BottomNavBar());
            } else if (userType == "admin") {
              return Material(child: WorkoutsFullLenght());
            } else {
              return const Scaffold(
                body: Center(child: Text("User type not recognized")),
              );
            }
          } else if (userSnapshot.hasError) {
            print('Error in userSnapshot: ${userSnapshot.error}');
            return const Scaffold(
              body: Center(child: Text("An error occurred. Please try again.")),
            );
          }

          return HomePage();
        },
      ),
    );
  }
}
