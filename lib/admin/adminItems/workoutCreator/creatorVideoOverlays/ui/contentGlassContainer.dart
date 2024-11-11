import 'package:flutter/material.dart';

class ContentGlassContainer extends StatelessWidget {
  final String workoutName;
  final String bodyPart;
  final String topic;
  final String content1;
  final String content2;
  const ContentGlassContainer(
      {super.key,
      required this.workoutName,
      required this.bodyPart,
      required this.topic,
      required this.content1,
      required this.content2});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        new ClipRect(
          child: new Container(
            width: widthDevice * 0.85,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey.shade200.withOpacity(0.3)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 14,
                        height: 2
                      ),
                      children: [
                        TextSpan(text: 'Workout Name: '),
                        TextSpan(text: workoutName)
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 14,
                        height: 2
                      ),
                      children: [
                        TextSpan(text: 'Body Part: '),
                        TextSpan(text: bodyPart)
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 14,
                        height: 2
                      ),
                      children: [
                        TextSpan(text: 'Topic: '),
                        TextSpan(text: topic)
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 14,
                        height: 2
                      ),
                      children: [
                        TextSpan(text: 'Content:\n'),
                        TextSpan(text: '1. $content1\n'),
                        TextSpan(text: '2. $content2'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
