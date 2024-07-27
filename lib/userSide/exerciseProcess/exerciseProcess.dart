import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/videoScreen.dart';

class ExerciseProcess extends StatefulWidget {
  final Map entireExercise;
  const ExerciseProcess({super.key, required this.entireExercise});

  @override
  State<ExerciseProcess> createState() => _ExerciseProcessState();
}

class _ExerciseProcessState extends State<ExerciseProcess> {
  //var
  List exerciseBuildList = [];
  var exerciseIndex = 0;

//change index
  changePageIndex(value) {
    setState(() {
      exerciseIndex = value;
    });
  }

//breakDown Excercise list to get order
  orderList() async {
    var exerciseBuild = {
      "type": "",
      "mediaType": "",
      "mediaTypeUrl": "",
      "image": "",
      "timer": "",
      "repsTotal": "",
    };

    var restBuild = {
      "type": "",
      "mediaType": "",
      "mediaTypeUrl": "",
      "image": "",
      "timer": "",
      "repsTotal": "",
    };

    for (var i = 0; i < (widget.entireExercise['warmUps']).length; i++) {
      var warmUpData = widget.entireExercise['warmUps'][i];
      print(warmUpData['name']);
      for (var r = 0; r < (int.parse(warmUpData['repetition'])); r++) {
        /*     exerciseBuild = {
          "type": "warmUp",
          "mediaType": warmUpData['videoUrl'] == "" ? "Audio" : "Video",
          "mediaTypeUrl": warmUpData['videoUrl'] == ""
              ? warmUpData['audioUrl']
              : warmUpData['videoUrl'],
          "image": warmUpData['image'],
          "timer": warmUpData['time'],
          "repsTotal": warmUpData['repetition'],
        };

        restBuild = {
          "type": "rest",
          "mediaType": "",
          "mediaTypeUrl": "",
          "image": warmUpData['image'],
          "timer": widget.entireExercise['time'],
          "repsTotal": "",
        };
      */
        setState(() {
          exerciseBuildList.add(exerciseBuild);
          exerciseBuildList.add(restBuild);
        });
      } /**/
    }
    print("exerciseBuildList");
    print(exerciseBuildList);
  }

  @override
  void initState() {
    orderList();
    print("TEST");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*  Visibility(
            visible: exerciseBuildList[exerciseIndex]['type'] == "Video",
            child: VideoScreen(
              changePageIndex: changePageIndex,
              videoUrl: exerciseBuildList[exerciseIndex]['mediaTypeUrl'],
            ))*/
      ],
    );
  }
}
