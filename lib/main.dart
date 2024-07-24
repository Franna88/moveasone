import 'package:flutter/material.dart';
import 'package:move_as_one/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:move_as_one/Services/UserState.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
          child: UserState(),
        ));
  }
}
