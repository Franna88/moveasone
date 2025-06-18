import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/audioScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/doneScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/enhancedVideoScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/enhancedRestScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/phaseTransitionScreen.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/setsAndRepsTracker.dart';
import 'package:move_as_one/userSide/exerciseProcess/widgets/workoutProgressIndicator.dart';

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
  bool showingPhaseTransition = false;

  // Phase tracking
  int totalWarmups = 0;
  int totalWorkouts = 0;
  int totalCooldowns = 0;
  String currentPhase = '';
  int currentPhaseIndex = 0;
  int totalExercisesInCurrentPhase = 0;

  // Sets and Reps tracking
  Map<String, dynamic>? currentExerciseData;
  int currentSetIndex = 0;
  int totalSetsForCurrentExercise = 1;
  bool isInRestBetweenSets = false;

//change index
  changePageIndex() {
    // Check if we need to show a phase transition
    if (_shouldShowPhaseTransition()) {
      _showPhaseTransition();
    } else {
      setState(() {
        exerciseIndex++;
        _updateCurrentPhaseInfo();
      });
    }
  }

  bool _shouldShowPhaseTransition() {
    if (exerciseIndex >= exerciseBuildList.length - 1) return false;

    String currentType = exerciseBuildList[exerciseIndex]['type'];
    String nextType = exerciseBuildList[exerciseIndex + 1]['type'];

    // Show transition when moving between different phases (skip rest)
    return currentType != nextType && nextType != 'rest';
  }

  void _showPhaseTransition() {
    if (exerciseIndex >= exerciseBuildList.length - 1) return;

    String nextPhase = exerciseBuildList[exerciseIndex + 1]['type'];
    String nextExerciseName =
        exerciseBuildList[exerciseIndex + 1]['name'] ?? 'Next Exercise';

    // Calculate remaining exercises in next phase
    int remainingInPhase =
        _getRemainingExercisesInPhase(nextPhase, exerciseIndex + 1);

    setState(() {
      showingPhaseTransition = true;
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PhaseTransitionScreen(
          fromPhase: currentPhase,
          toPhase: nextPhase,
          nextExerciseName: nextExerciseName,
          totalPhasesRemaining: remainingInPhase,
          onContinue: () {
            Navigator.pop(context);
            setState(() {
              showingPhaseTransition = false;
              exerciseIndex++;
              _updateCurrentPhaseInfo();
            });
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  int _getRemainingExercisesInPhase(String phase, int startIndex) {
    int count = 0;
    for (int i = startIndex; i < exerciseBuildList.length; i++) {
      if (exerciseBuildList[i]['type'] == phase &&
          exerciseBuildList[i]['type'] != 'rest') {
        count++;
      } else if (exerciseBuildList[i]['type'] != phase &&
          exerciseBuildList[i]['type'] != 'rest') {
        break;
      }
    }
    return count;
  }

  void _updateCurrentPhaseInfo() {
    if (exerciseIndex < exerciseBuildList.length) {
      currentPhase = exerciseBuildList[exerciseIndex]['type'];

      // Calculate current position in phase
      currentPhaseIndex = 0;
      totalExercisesInCurrentPhase = 0;

      // Count exercises before current index in same phase
      for (int i = 0; i < exerciseIndex; i++) {
        if (exerciseBuildList[i]['type'] == currentPhase &&
            exerciseBuildList[i]['type'] != 'rest') {
          currentPhaseIndex++;
        }
      }

      // Count total exercises in current phase
      for (int i = 0; i < exerciseBuildList.length; i++) {
        if (exerciseBuildList[i]['type'] == currentPhase &&
            exerciseBuildList[i]['type'] != 'rest') {
          totalExercisesInCurrentPhase++;
        }
      }
    }
  }

//breakDown Excercise list to get order
  orderList() async {
    // Count totals first
    if (widget.entireExercise['warmUps'] != null &&
        widget.entireExercise['warmUps'] is List) {
      totalWarmups = widget.entireExercise['warmUps'].length;
    }

    if (widget.entireExercise['workouts'] != null &&
        widget.entireExercise['workouts'] is List) {
      totalWorkouts = widget.entireExercise['workouts'].length;
    } else if (widget.entireExercise['exercises'] != null &&
        widget.entireExercise['exercises'] is List) {
      totalWorkouts = widget.entireExercise['exercises'].length;
    }

    if (widget.entireExercise['coolDowns'] != null &&
        widget.entireExercise['coolDowns'] is List) {
      totalCooldowns = widget.entireExercise['coolDowns'].length;
    } else if (widget.entireExercise['cooldowns'] != null &&
        widget.entireExercise['cooldowns'] is List) {
      totalCooldowns = widget.entireExercise['cooldowns'].length;
    }

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

    // Initialize current phase info
    _updateCurrentPhaseInfo();

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

      // Create a single exercise entry with complete sets/reps data
      var exerciseBuild = {
        "type": groupType,
        "mediaType":
            (exerciseData['videoUrl'] == null || exerciseData['videoUrl'] == "")
                ? "Audio"
                : "Video",
        "mediaTypeUrl":
            (exerciseData['videoUrl'] == null || exerciseData['videoUrl'] == "")
                ? exerciseData['audioUrl'] ?? ""
                : exerciseData['videoUrl'] ?? "",
        "image": exerciseData['imageUrl'] ?? exerciseData['image'] ?? "",
        "repsPerSet": int.tryParse(repsPerSet) ?? 1,
        "totalSets": setCount,
        "restBetweenSets": restTimeBetweenSets,
        "isTimeBased": isTimeBased,
        "duration": exerciseDuration,
        "name": exerciseData['name'] ?? "Exercise",
        "description": exerciseData['description'] ?? "",
        "difficulty": exerciseData['difficulty'] ?? "Basic",
        "equipment": exerciseData['equipment'] ?? "No Equipment",
        "exerciseType":
            "setsAndReps", // New field to indicate this uses our enhanced tracker
        // Legacy compatibility fields
        "repsTotal": repsPerSet,
        "repCounter": 1,
        "setTotal": setCount.toString(),
      };

      setState(() {
        exerciseBuildList.add(exerciseBuild);
      });

      // Add rest between exercises (not between sets)
      bool isLastExercise = (i == exerciseGroup.length - 1);
      if (!isLastExercise) {
        var restBuild = {
          "type": "rest",
          "mediaType": "Rest",
          "mediaTypeUrl": "",
          "image": exerciseData['imageUrl'] ?? exerciseData['image'] ?? "",
          "repsTotal": "1",
          "repCounter": 1,
          "name": "Rest",
          "description": "Take a break before the next exercise",
          'timer': restTimeBetweenSets,
        };

        setState(() {
          exerciseBuildList.add(restBuild);
        });
      }
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Workout?'),
          content: const Text(
            'Are you sure you want to exit? Your progress will not be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.popUntil(
                    context, (route) => route.isFirst); // Exit to home
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
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
        nextExerciseName = (exerciseBuildList[nextIndex]['name'] as String?) ??
            "Next Exercise";
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced Sets & Reps Exercise Screen (for exercises with multiple sets)
          Visibility(
            visible: (exerciseBuildList[exerciseIndex]['exerciseType']
                        as String?) ==
                    "setsAndReps" &&
                (exerciseBuildList[exerciseIndex]['type'] as String?) != 'rest',
            child: SetsAndRepsTracker(
              exerciseData: {
                'name': (exerciseBuildList[exerciseIndex]['name'] as String?) ??
                    "Exercise",
                'setTotal':
                    (exerciseBuildList[exerciseIndex]['totalSets'] as int?) ??
                        1,
                'repsTotal':
                    (exerciseBuildList[exerciseIndex]['repsPerSet'] as int?) ??
                        1,
                'timer': (exerciseBuildList[exerciseIndex]['restBetweenSets']
                        as int?) ??
                    30,
                'image':
                    (exerciseBuildList[exerciseIndex]['image'] as String?) ??
                        "",
                'videoUrl': (exerciseBuildList[exerciseIndex]['mediaTypeUrl']
                        as String?) ??
                    "",
                'isTimeBased': (exerciseBuildList[exerciseIndex]['isTimeBased']
                        as bool?) ??
                    false,
                'duration':
                    (exerciseBuildList[exerciseIndex]['duration'] as int?) ??
                        30,
              },
              onExerciseComplete: () {
                // When all sets are complete, move to next exercise
                changePageIndex();
              },
              onStatusUpdate: (String status) {
                // Update workout status - you can use this for feedback to user
                print('Sets & Reps Status: $status');
              },
            ),
          ),

          // Video screen (for single-set exercises or legacy format)
          Visibility(
            visible: (exerciseBuildList[exerciseIndex]['mediaType']
                        as String?) ==
                    "Video" &&
                (exerciseBuildList[exerciseIndex]['exerciseType'] as String?) !=
                    "setsAndReps",
            child: EnhancedVideoScreen(
              changePageIndex: changePageIndex,
              videoUrl: (exerciseBuildList[exerciseIndex]['mediaTypeUrl']
                      as String?) ??
                  "",
              workoutType:
                  (exerciseBuildList[exerciseIndex]['type'] as String?) ?? "",
              reps:
                  (exerciseBuildList[exerciseIndex]['repsTotal']?.toString()) ??
                      "1",
              repsCounter:
                  (exerciseBuildList[exerciseIndex]['repCounter'] as int?) ?? 1,
              title: (exerciseBuildList[exerciseIndex]['name'] as String?) ??
                  "Exercise",
              description: (exerciseBuildList[exerciseIndex]['description']
                      as String?) ??
                  "",
              isTimeBased:
                  (exerciseBuildList[exerciseIndex]['isTimeBased'] as bool?) ??
                      false,
              duration:
                  (exerciseBuildList[exerciseIndex]['duration'] as int?) ?? 30,
            ),
          ),

          // Audio screen (for single-set exercises or legacy format)
          Visibility(
            visible: (exerciseBuildList[exerciseIndex]['mediaType']
                        as String?) ==
                    "Audio" &&
                (exerciseBuildList[exerciseIndex]['exerciseType'] as String?) !=
                    "setsAndReps",
            child: AudioScreen(
              changePageIndex: changePageIndex,
              audioUrl: (exerciseBuildList[exerciseIndex]['mediaTypeUrl']
                      as String?) ??
                  "",
              imageUrl:
                  (exerciseBuildList[exerciseIndex]['image'] as String?) ?? "",
              workoutType:
                  (exerciseBuildList[exerciseIndex]['type'] as String?) ?? "",
              reps:
                  (exerciseBuildList[exerciseIndex]['repsTotal']?.toString()) ??
                      "1",
              repsCounter:
                  (exerciseBuildList[exerciseIndex]['repCounter'] as int?) ?? 1,
              title: (exerciseBuildList[exerciseIndex]['name'] as String?) ??
                  "Exercise",
              description: (exerciseBuildList[exerciseIndex]['description']
                      as String?) ??
                  "",
            ),
          ),

          // Rest screen
          Visibility(
            visible:
                (exerciseBuildList[exerciseIndex]['mediaType'] as String?) ==
                        "Rest" &&
                    exerciseIndex != exerciseBuildList.length - 1,
            child: EnhancedRestScreen(
              changePageIndex: changePageIndex,
              imageUrl:
                  (exerciseBuildList[exerciseIndex]['image'] as String?) ?? "",
              time: (exerciseBuildList[exerciseIndex]['timer'] as int?) ?? 0,
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

          // Exit button (top-left corner)
          Positioned(
            top: 50,
            left: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => _showExitConfirmation(context),
                ),
              ),
            ),
          ),

          // Workout Progress Indicator (only show for non-setsAndReps exercises)
          if (exerciseIndex < exerciseBuildList.length - 1 &&
              (exerciseBuildList[exerciseIndex]['exerciseType'] as String?) !=
                  "setsAndReps")
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  WorkoutProgressIndicator(
                    currentPhase: currentPhase,
                    currentExerciseIndex: currentPhaseIndex,
                    totalExercisesInPhase: totalExercisesInCurrentPhase,
                    totalWarmups: totalWarmups,
                    totalWorkouts: totalWorkouts,
                    totalCooldowns: totalCooldowns,
                  ),
                  const SizedBox(height: 8),
                  if (currentPhase != 'rest')
                    WorkoutPhaseProgress(
                      currentPhase: currentPhase,
                      currentExerciseIndex: (exerciseBuildList[exerciseIndex]
                                  ['type'] as String?) !=
                              'rest'
                          ? currentPhaseIndex
                          : currentPhaseIndex - 1,
                      totalExercisesInPhase: totalExercisesInCurrentPhase,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
