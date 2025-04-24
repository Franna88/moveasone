import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/audioScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/doneScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/enhancedRestScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/enhancedVideoScreen.dart';

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
  bool isLoading = true;

//change index
  changePageIndex() {
    setState(() {
      exerciseIndex++;
    });
    setState(() {});
  }

//breakDown Excercise list to get order
  orderList() async {
    // Process warm-ups if they exist
    if (widget.entireExercise['warmUps'] != null &&
        widget.entireExercise['warmUps'] is List &&
        widget.entireExercise['warmUps'].isNotEmpty) {
      processExerciseGroup(widget.entireExercise['warmUps'], "warmUp");
    }

    // Process workouts if they exist
    if (widget.entireExercise['workouts'] != null &&
        widget.entireExercise['workouts'] is List &&
        widget.entireExercise['workouts'].isNotEmpty) {
      processExerciseGroup(widget.entireExercise['workouts'], "workouts");
    }

    // Process exercises if they exist (newer format)
    if (widget.entireExercise['exercises'] != null &&
        widget.entireExercise['exercises'] is List &&
        widget.entireExercise['exercises'].isNotEmpty) {
      processExerciseGroup(widget.entireExercise['exercises'], "workouts");
    }

    // Process cooldowns if they exist
    if (widget.entireExercise['coolDowns'] != null &&
        widget.entireExercise['coolDowns'] is List &&
        widget.entireExercise['coolDowns'].isNotEmpty) {
      processExerciseGroup(widget.entireExercise['coolDowns'], "coolDowns");
    }

    // Process cooldowns if they exist (newer format)
    if (widget.entireExercise['cooldowns'] != null &&
        widget.entireExercise['cooldowns'] is List &&
        widget.entireExercise['cooldowns'].isNotEmpty) {
      processExerciseGroup(widget.entireExercise['cooldowns'], "coolDowns");
    }

    // Handle case where no exercises were found
    if (exerciseBuildList.isEmpty) {
      // Add a dummy "done" exercise so the UI can render the DoneScreen
      var exerciseBuild = {
        "type": "done",
        "mediaType": "Rest",
        "mediaTypeUrl": "",
        "image": widget.entireExercise['displayImage'] ??
            widget.entireExercise['imageUrl'] ??
            "",
        "repsTotal": "1",
        "repCounter": 1,
        "name": "Workout Complete",
        "description": "No exercises were found in this workout",
      };

      setState(() {
        exerciseBuildList.add(exerciseBuild);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // Process a group of exercises (warmups, workouts, or cooldowns)
  void processExerciseGroup(List exerciseGroup, String groupType) {
    for (var i = 0; i < exerciseGroup.length; i++) {
      var exerciseData = exerciseGroup[i];
      if (exerciseData == null) continue;

      // Get number of sets
      int setCount = 1;
      if (exerciseData['sets'] != null && exerciseData['sets'] is num) {
        setCount = exerciseData['sets'];
      }

      // Get number of reps per set
      String repsPerSet = "1";
      if (exerciseData['reps'] != null) {
        repsPerSet = exerciseData['reps'].toString();
      } else if (exerciseData['repetition'] != null) {
        repsPerSet = exerciseData['repetition'].toString();
      }

      // Get rest time between sets
      int restTimeBetweenSets = 30; // Default rest time
      if (exerciseData['restBetweenSets'] != null &&
          exerciseData['restBetweenSets'] is num) {
        restTimeBetweenSets = exerciseData['restBetweenSets'];
      }

      // Check if it's a time-based exercise
      bool isTimeBased = false;
      int exerciseDuration = 30; // Default duration in seconds

      if (exerciseData['isTimeBased'] != null &&
          exerciseData['isTimeBased'] is bool) {
        isTimeBased = exerciseData['isTimeBased'];
      }

      if (exerciseData['duration'] != null && exerciseData['duration'] is num) {
        exerciseDuration = exerciseData['duration'];
      }

      // Process each set of the exercise
      for (var setIndex = 0; setIndex < setCount; setIndex++) {
        var exerciseBuild = {
          "type": groupType,
          "mediaType": (exerciseData['videoUrl'] == null ||
                  exerciseData['videoUrl'] == "")
              ? "Audio"
              : "Video",
          "mediaTypeUrl": (exerciseData['videoUrl'] == null ||
                  exerciseData['videoUrl'] == "")
              ? exerciseData['audioUrl'] ?? ""
              : exerciseData['videoUrl'] ?? "",
          "image": exerciseData['imageUrl'] ?? exerciseData['image'] ?? "",
          "repsTotal": repsPerSet,
          "repCounter": setIndex + 1,
          "setTotal": setCount.toString(),
          "isTimeBased": isTimeBased,
          "duration": exerciseDuration,
          "name": exerciseData['name'] ?? "Exercise",
          "description": exerciseData['description'] ?? "",
          "difficulty": exerciseData['difficulty'] ?? "Basic",
          "equipment": exerciseData['equipment'] ?? "No Equipment",
        };

        // Add rest after each set except the last one of the last exercise
        bool isLastSet = (setIndex == setCount - 1);
        bool isLastExercise = (i == exerciseGroup.length - 1);

        if (!isLastSet || !isLastExercise) {
          var restBuild = {
            "type": "rest",
            "mediaType": "Rest",
            "mediaTypeUrl": "",
            "image": exerciseData['imageUrl'] ?? exerciseData['image'] ?? "",
            "repsTotal": "1",
            "repCounter": 1,
            "name": "Rest",
            "description": isLastSet
                ? "Take a break before the next exercise"
                : "Rest between sets",
            'timer': restTimeBetweenSets,
          };

          setState(() {
            exerciseBuildList.add(exerciseBuild);
            exerciseBuildList.add(restBuild);
          });
        } else {
          setState(() {
            exerciseBuildList.add(exerciseBuild);
          });
        }
      }
    }
  }

  @override
  void initState() {
    orderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || exerciseBuildList.isEmpty) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Determine the name of the next exercise
    String nextExerciseName = "Next Exercise";
    if (exerciseIndex < exerciseBuildList.length - 1) {
      // Look ahead to find the next non-rest exercise
      int nextIndex = exerciseIndex + 1;
      while (nextIndex < exerciseBuildList.length &&
          exerciseBuildList[nextIndex]['type'] == 'rest') {
        nextIndex++;
      }

      if (nextIndex < exerciseBuildList.length) {
        nextExerciseName =
            exerciseBuildList[nextIndex]['name'] ?? "Next Exercise";
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Video screen
          Visibility(
            visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Video",
            child: EnhancedVideoScreen(
              changePageIndex: changePageIndex,
              videoUrl: exerciseBuildList[exerciseIndex]['mediaTypeUrl'],
              workoutType: exerciseBuildList[exerciseIndex]['type'],
              reps: exerciseBuildList[exerciseIndex]['repsTotal'],
              repsCounter: exerciseBuildList[exerciseIndex]['repCounter'],
              title:
                  "${exerciseBuildList[exerciseIndex]['name']} (Set ${exerciseBuildList[exerciseIndex]['repCounter']}/${exerciseBuildList[exerciseIndex]['setTotal'] ?? '1'})",
              description: exerciseBuildList[exerciseIndex]['description'],
              isTimeBased:
                  exerciseBuildList[exerciseIndex]['isTimeBased'] ?? false,
              duration: exerciseBuildList[exerciseIndex]['duration'] ?? 30,
            ),
          ),

          // Audio screen
          Visibility(
            visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Audio",
            child: AudioScreen(
              changePageIndex: changePageIndex,
              audioUrl: exerciseBuildList[exerciseIndex]['mediaTypeUrl'],
              imageUrl: exerciseBuildList[exerciseIndex]['image'],
              workoutType: exerciseBuildList[exerciseIndex]['type'],
              reps: exerciseBuildList[exerciseIndex]['repsTotal'],
              repsCounter: exerciseBuildList[exerciseIndex]['repCounter'],
              title:
                  "${exerciseBuildList[exerciseIndex]['name']} (Set ${exerciseBuildList[exerciseIndex]['repCounter']}/${exerciseBuildList[exerciseIndex]['setTotal'] ?? '1'})",
              description: exerciseBuildList[exerciseIndex]['description'],
            ),
          ),

          // Rest screen
          Visibility(
            visible: exerciseBuildList[exerciseIndex]['mediaType'] == "Rest" &&
                exerciseIndex != exerciseBuildList.length - 1,
            child: EnhancedRestScreen(
              changePageIndex: changePageIndex,
              imageUrl: exerciseBuildList[exerciseIndex]['image'],
              time: exerciseBuildList[exerciseIndex]['timer'] ?? 0,
              nextExerciseName: nextExerciseName,
            ),
          ),

          // Done screen
          Visibility(
            visible: exerciseIndex == exerciseBuildList.length - 1,
            child: DoneScreen(
              entireExercise: widget.entireExercise,
            ),
          ),
        ],
      ),
    );
  }
}
