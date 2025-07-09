import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/HomePage.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/services/debug_service.dart';
import 'package:move_as_one/services/admin_user_service.dart';

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
    DebugService().logWidgetLifecycle('UserState', 'initState');
    _checkUserType();
  }

  void _checkUserType() async {
    DebugService().startPerformanceTimer('checkUserType');
    DebugService().log('Starting user type check', LogLevel.info, tag: 'AUTH');

    try {
      // Initialize admin user when app starts
      AdminUserService.ensureAdminUserExists();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DebugService()
            .log('User authenticated: ${user.uid}', LogLevel.info, tag: 'AUTH');

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        DebugService().logFirebaseOperation('read',
            collection: 'users', documentId: user.uid, success: userDoc.exists);

        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data['status'] != null) {
          setState(() {
            userType = data['status'];
          });
          DebugService().log(
              'User type determined: ${data['status']}', LogLevel.info,
              tag: 'AUTH');
        } else {
          DebugService().log(
              'User data not found or status missing', LogLevel.warning,
              tag: 'AUTH');
        }
      } else {
        DebugService()
            .log('No authenticated user found', LogLevel.info, tag: 'AUTH');
      }
    } catch (e, stackTrace) {
      DebugService()
          .logError('Error checking user type', e, stackTrace, tag: 'AUTH');
    } finally {
      setState(() {
        isLoading = false;
      });
      DebugService().endPerformanceTimer('checkUserType');
    }
  }

  Future<bool> _onWillPop() async {
    DebugService().logUserAction('back_button_pressed', screen: 'UserState');

    // Define default navigation logic for the back button
    if (userType == "user") {
      DebugService().logNavigation('UserState', 'BottomNavBar');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (Route<dynamic> route) => false,
      );
    } else {
      DebugService().logNavigation('UserState', 'WorkoutsFullLenght');
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
            DebugService().log(
                'User authenticated, routing based on type: $userType',
                LogLevel.info,
                tag: 'AUTH');
            if (userType == "user") {
              DebugService().logNavigation('UserState', 'BottomNavBar');
              return Material(child: BottomNavBar());
            } else if (userType == "admin") {
              DebugService().logNavigation('UserState', 'WorkoutsFullLenght');
              return Material(child: WorkoutsFullLenght());
            } else {
              DebugService().log(
                  'Unrecognized user type: $userType', LogLevel.warning,
                  tag: 'AUTH');
              return const Scaffold(
                body: Center(child: Text("User type not recognized")),
              );
            }
          } else if (userSnapshot.hasError) {
            DebugService().logError(
                'Auth stream error', userSnapshot.error, null,
                tag: 'AUTH');
            return const Scaffold(
              body: Center(child: Text("An error occurred. Please try again.")),
            );
          }

          DebugService().logNavigation('UserState', 'HomePage');
          return HomePage();
        },
      ),
    );
  }
}
