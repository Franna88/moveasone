import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/audioScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/rest.dart';
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
  late int exerciseIndex = 0;

//change index
  changePageIndex() {
    setState(() {
      exerciseIndex++;
    });
    setState(() {});
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
      "repCounter": 0
    };

    var restBuild = {
      "type": "",
      "mediaType": "",
      "mediaTypeUrl": "",
      "image": "",
      "timer": "",
      "repsTotal": "",
      "repCounter": 0
    };

    for (var i = 0; i < (widget.entireExercise['warmUps']).length; i++) {
      var warmUpData = widget.entireExercise['warmUps'][i];

      for (var r = 0; r < (int.parse(warmUpData['repetition'])); r++) {
        exerciseBuild = {
          "type": "warmUp",
          "mediaType": warmUpData['videoUrl'] == "" ? "Audio" : "Video",
          "mediaTypeUrl": warmUpData['videoUrl'] == ""
              ? warmUpData['audioUrl']
              : warmUpData['videoUrl'],
          "image": warmUpData['image'],
          "repsTotal": warmUpData['repetition'],
          "repCounter": r + 1
        };

        restBuild = {
          "type": "rest",
          "mediaType": "Rest",
          "mediaTypeUrl": "",
          "image": warmUpData['image'],
          "repsTotal": warmUpData['repetition'],
          "repCounter": r + 1
        };

        setState(() {
          exerciseBuildList.add(exerciseBuild);
          exerciseBuildList.add(restBuild);
        });
      }
    }
    for (var i = 0; i < (widget.entireExercise['workouts']).length; i++) {
      var warmUpData = widget.entireExercise['workouts'][i];

      for (var r = 0; r < (int.parse(warmUpData['repetition'])); r++) {
        exerciseBuild = {
          "type": "warmUp",
          "mediaType": warmUpData['videoUrl'] == "" ? "Audio" : "Video",
          "mediaTypeUrl": warmUpData['videoUrl'] == ""
              ? warmUpData['audioUrl']
              : warmUpData['videoUrl'],
          "image": warmUpData['image'],
          "repsTotal": warmUpData['repetition'],
          "repCounter": r + 1
        };

        restBuild = {
          "type": "rest",
          "mediaType": "Rest",
          "mediaTypeUrl": "",
          "image": warmUpData['image'],
          "repsTotal": warmUpData['repetition'],
          "repCounter": r + 1
        };

        setState(() {
          exerciseBuildList.add(exerciseBuild);
          exerciseBuildList.add(restBuild);
        });
      }
    }
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
        Visibility(
          visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Video",
          child: Material(
              child: VideoScreen(
            changePageIndex: changePageIndex,
            videoUrl: exerciseBuildList[exerciseIndex]['mediaTypeUrl'],
            workoutType: exerciseBuildList[exerciseIndex]['type'],
            repsCounter: exerciseBuildList[exerciseIndex]['repCounter'],
          )),
        ),
        Visibility(
            visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Audio",
            child: Material(
              child: AudioScreen(
                changePageIndex: changePageIndex,
                audioUrl: exerciseBuildList[exerciseIndex]['mediaTypeUrl'],
                imageUrl: exerciseBuildList[exerciseIndex]['image'],
                workoutType: exerciseBuildList[exerciseIndex]['type'],
                reps: exerciseBuildList[exerciseIndex]['repsTotal'],
                repsCounter: exerciseBuildList[exerciseIndex]['repCounter'],
              ),
            )),
        Visibility(
          visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Rest",
          child: Material(
            child: Rest(
              changePageIndex: changePageIndex,
              imageUrl: exerciseBuildList[exerciseIndex]['image'],
            ),
          ),
        ),
      ],
    );
  }
}
