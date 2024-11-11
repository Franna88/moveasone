import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/audioScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/doneScreen.dart';
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
      "repCounter": 0,
      "name": "",
      "description": ""
    };

    var restBuild = {
      "type": "",
      "mediaType": "",
      "mediaTypeUrl": "",
      "image": "",
      "timer": "",
      "repsTotal": "",
      "repCounter": 0,
      "name": "",
      "description": ""
    };

    for (var i = 0; i < (widget.entireExercise['warmUps']).length; i++) {
      var warmUpData = widget.entireExercise['warmUps'][i];

      int totalRestTimeInSeconds = (warmUpData['selectedMinutes'] ?? 0) * 60 +
          (warmUpData['selectedSeconds'] ?? 0);

      for (var r = 0; r < (int.parse(warmUpData['repetition'])); r++) {
        exerciseBuild = {
          "type": "warmUp",
          "mediaType": warmUpData['videoUrl'] == "" ? "Audio" : "Video",
          "mediaTypeUrl": warmUpData['videoUrl'] == ""
              ? warmUpData['audioUrl']
              : warmUpData['videoUrl'],
          "image": warmUpData['image'],
          "repsTotal": warmUpData['repetition'],
          "repCounter": r + 1,
          "name": warmUpData['name'],
          "description": warmUpData['description'],
        };

        restBuild = {
          "type": "rest",
          "mediaType": "Rest",
          "mediaTypeUrl": "",
          "image": warmUpData['image'],
          "repsTotal": warmUpData['repetition'],
          "repCounter": r + 1,
          "name": warmUpData['name'],
          "description": warmUpData['description'],
          'timer': totalRestTimeInSeconds,
        };

        setState(() {
          exerciseBuildList.add(exerciseBuild);
          exerciseBuildList.add(restBuild);
        });
      }
    }
    for (var i = 0; i < (widget.entireExercise['workouts']).length; i++) {
      var workout = widget.entireExercise['workouts'][i];

      int totalRestTimeInSeconds =
          ((workout['selectedMinutes'] ?? 0) as int) * 60 +
              ((workout['selectedSeconds'] ?? 0) as int);

      for (var r = 0; r < (int.parse(workout['repetition'])); r++) {
        exerciseBuild = {
          "type": "workouts",
          "mediaType": workout['videoUrl'] == "" ? "Audio" : "Video",
          "mediaTypeUrl": workout['videoUrl'] == ""
              ? workout['audioUrl']
              : workout['videoUrl'],
          "image": workout['image'],
          "repsTotal": workout['repetition'],
          "repCounter": r + 1,
          "name": workout['name'],
          "description": workout['description'],
        };

        restBuild = {
          "type": "rest",
          "mediaType": "Rest",
          "mediaTypeUrl": "",
          "image": workout['image'],
          "repsTotal": workout['repetition'],
          "repCounter": r + 1,
          "name": workout['name'],
          "description": workout['description'],
          'timer': totalRestTimeInSeconds,
        };

        setState(() {
          exerciseBuildList.add(exerciseBuild);
          exerciseBuildList.add(restBuild);
        });
      }
    }

    for (var i = 0; i < (widget.entireExercise['coolDowns']).length; i++) {
      var coolDown = widget.entireExercise['coolDowns'][i];

      int totalRestTimeInSeconds =
          ((coolDown['selectedMinutes'] ?? 0) as int) * 60 +
              ((coolDown['selectedSeconds'] ?? 0) as int);

      for (var r = 0; r < (int.parse(coolDown['repetition'])); r++) {
        exerciseBuild = {
          "type": "coolDowns",
          "mediaType": coolDown['videoUrl'] == "" ? "Audio" : "Video",
          "mediaTypeUrl": coolDown['videoUrl'] == ""
              ? coolDown['audioUrl']
              : coolDown['videoUrl'],
          "image": coolDown['image'],
          "repsTotal": coolDown['repetition'],
          "repCounter": r + 1,
          "name": coolDown['name'],
          "description": coolDown['description'],
        };

        restBuild = {
          "type": "rest",
          "mediaType": "Rest",
          "mediaTypeUrl": "",
          "image": coolDown['image'],
          "repsTotal": coolDown['repetition'],
          "repCounter": r + 1,
          "name": coolDown['name'],
          "description": coolDown['description'],
          'timer': totalRestTimeInSeconds,
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
            reps: exerciseBuildList[exerciseIndex]['repsTotal'],
            repsCounter: exerciseBuildList[exerciseIndex]['repCounter'],
            title: exerciseBuildList[exerciseIndex]['name'],
            description: exerciseBuildList[exerciseIndex]['description'],
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
                title: exerciseBuildList[exerciseIndex]['name'],
                description: exerciseBuildList[exerciseIndex]['description'],
              ),
            )),
        Visibility(
          visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Rest" &&
              exerciseIndex != exerciseBuildList.length - 1,
          child: Material(
            child: Rest(
              changePageIndex: changePageIndex,
              imageUrl: exerciseBuildList[exerciseIndex]['image'],
              time: exerciseBuildList[exerciseIndex]['timer'] ?? 0,
            ),
          ),
        ),
        Visibility(
            visible: exerciseIndex == exerciseBuildList.length - 1,
            child: DoneScreen(
              entireExercise: widget.entireExercise,
            )),
      ],
    );
  }
}
