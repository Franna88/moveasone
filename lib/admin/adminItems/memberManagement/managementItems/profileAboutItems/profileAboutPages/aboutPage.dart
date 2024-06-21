import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: const Text(
        'Meet Lena Rosser, a dedicated fitness trainer with 5 years of experience in the field. Lena has a passion for helping others achieve their fitness goals and believes that a healthy lifestyle is the key to a happy and fulfilling life.\n\nAs a trainer, Lena focuses on creating personalized workout plans that cater to each client\'s individual needs and abilities. She uses a variety of techniques, including strength training, cardio, and flexibility exercises to help her clients achieve their desired results.',
        style: TextStyle(fontFamily: 'Inter-Medium' , fontSize: 14 ),
      ),
    );
  }
}
