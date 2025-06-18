import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/IntroVideoScreen.dart';
import 'package:move_as_one/Services/debug_service.dart';

class AuthService {
  successProcess(context) {
    Fluttertoast.showToast(
        msg: 'Sign-up successful!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => IntroVideoScreen()),
    );
  }

  //sign up
  Future<void> Signup(
      {required String email,
      required String password,
      required String userName,
      required BuildContext context,
      required String goal,
      required String gender,
      required String height,
      required String weight,
      required String weightUnit,
      required String age,
      required String activityLevel,
      int hiFive = 0}) async {
    DebugService().startPerformanceTimer('firebase_signup');
    DebugService()
        .log('Attempting signup for email: $email', LogLevel.info, tag: 'AUTH');

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      DebugService().log(
          'Firebase auth account created successfully', LogLevel.info,
          tag: 'AUTH');
      DebugService().logFirebaseOperation('createUser', success: true);

      var userAccountDetails = {
        "name": userName,
        "profilePic": "",
        "bio": "",
        "website": "",
        "email": email,
        "id": userCredential.user!.uid,
        "status": "user",
        "goal": goal,
        "gender": gender,
        "age": age,
        "height": height,
        "weight": weight,
        "activityLevel": activityLevel,
        "userVideos": [],
        "userExercises": [],
        'friendsList': [],
        "hiFive": hiFive
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(userAccountDetails)
          .whenComplete(() {
        DebugService().log('User document created in Firestore', LogLevel.info,
            tag: 'AUTH');
        DebugService().logFirebaseOperation('create',
            collection: 'users',
            documentId: userCredential.user!.uid,
            success: true);
        successProcess(context);
      });

      // Navigate to Longin after a successful sign-up
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }

      DebugService().logError('Signup failed', e, StackTrace.current,
          tag: 'AUTH',
          additionalData: {
            'email': email,
            'error_code': e.code,
            'error_message': e.message,
          });
      DebugService()
          .logFirebaseOperation('createUser', success: false, error: e.code);

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      DebugService().logError('Unexpected signup error', e, StackTrace.current,
          tag: 'AUTH', additionalData: {'email': email});

      Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      DebugService().endPerformanceTimer('firebase_signup');
    }
  }

  //sign in
  Future<void> Login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    DebugService().startPerformanceTimer('firebase_login');
    DebugService()
        .log('Attempting login for email: $email', LogLevel.info, tag: 'AUTH');

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DebugService().log('Login successful for email: $email', LogLevel.info,
          tag: 'AUTH');
      DebugService().logFirebaseOperation('signIn', success: true);

      Fluttertoast.showToast(
          msg: 'Long-in successful!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      // Navigate to HomePage after a successful sign-in
      DebugService().logNavigation('Signin', 'UserState');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => UserState()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'An error occurred. Please try again.';
      }

      DebugService().logError('Login failed', e, StackTrace.current,
          tag: 'AUTH',
          additionalData: {
            'email': email,
            'error_code': e.code,
            'error_message': e.message,
          });
      DebugService()
          .logFirebaseOperation('signIn', success: false, error: e.code);

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      DebugService().logError('Unexpected login error', e, StackTrace.current,
          tag: 'AUTH', additionalData: {'email': email});

      Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      DebugService().endPerformanceTimer('firebase_login');
    }
  }
}
