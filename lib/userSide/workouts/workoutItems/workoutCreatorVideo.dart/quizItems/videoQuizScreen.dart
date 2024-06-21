import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/ui/quizButton.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/ui/videoQuizProgressBar.dart';

class VideoQuizScreen extends StatefulWidget {
  const VideoQuizScreen({super.key});

  @override
  State<VideoQuizScreen> createState() => _VideoQuizScreenState();
}

class _VideoQuizScreenState extends State<VideoQuizScreen> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/placeHolder4.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 20, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [QuizPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
