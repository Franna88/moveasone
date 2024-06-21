import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/quizItems/ui/quizQuestions.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int totalQuestions = 6;

  void goToNextQuestion() {
    setState(() {
      if (currentQuestion < totalQuestions - 1) {
        currentQuestion++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
            value: (currentQuestion + 1) / totalQuestions,
            backgroundColor: const Color.fromARGB(255, 192, 191, 191),
            valueColor: AlwaysStoppedAnimation<Color>(
                const Color.fromARGB(255, 1, 102, 92)),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 30,
              ),
              Text(
                '${currentQuestion + 1} / $totalQuestions',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        FloatingActionButton(
          onPressed: () {
            goToNextQuestion();
          },
          child: Text('Next Question'),
        ),
        QuizQuestions(nextPage: () {
          goToNextQuestion();
        })
      ],
    );
  }
}
