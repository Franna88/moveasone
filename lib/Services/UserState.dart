import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/HomePage.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/userSide/Home/GetStarted.dart';

class UserState extends StatefulWidget {
  const UserState({super.key});

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  String userType = "";

  checkAdminType(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
    if (data?['status'] == null) {
      return false;
    }

    setState(() {
      userType = data?['status'];
    });
    //FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            return Material(
              child: HomePage(),
            );
          } else if (userSnapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;

            checkAdminType(user!.uid);

            if (userType == "user") {
              return Material(child: GetStarted());
            } else {
              return Material(child: WorkoutsFullLenght());
            }

// user logged in
          } else if (userSnapshot.hasError) {
            print('error on snapshot');
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          User? user = FirebaseAuth.instance.currentUser;
// user logged in

          return HomePage();
        });
  }
}
