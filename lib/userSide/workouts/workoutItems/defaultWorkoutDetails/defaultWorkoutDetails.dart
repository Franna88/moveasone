import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/warmUpCreator.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/deatilContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/dropDownContent.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/exerciseDropDown.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/exerciseVideoWidget.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/workoutCreatorVideoMain.dart';

class DefaultWorkoutDetails extends StatefulWidget {
  final String docId;
  final String userType;

  const DefaultWorkoutDetails(
      {super.key, required this.docId, required this.userType});

  @override
  State<DefaultWorkoutDetails> createState() => _DefaultWorkoutDetailsState();
}

class _DefaultWorkoutDetailsState extends State<DefaultWorkoutDetails> {
  bool isDroped = false;
  bool isActive = false;
  int? currentOpenDropdown;
  DocumentSnapshot? workout;

  var imageUrl = "";
  var difficulty = "";
  List selectedCategories = [];
  var bodyArea = "";
  var description = "";
  var time = 0;
  List warmUps = [];
  List workouts = [];
  List coolDowns = [];
  var test = "";

  List<Widget> warmupWidgets = [];
  List<Widget> workoutWidgets = [];
  List<Widget> cooldownWidgets = [];

  void toggleDropdown(int index) {
    setState(() {
      isActive = !isActive;
      isDroped = !isDroped;
      if (currentOpenDropdown == index) {
        currentOpenDropdown = null;
      } else {
        currentOpenDropdown = index;
      }
    });
  }

  Future<void> fetchWorkoutDetails() async {
    var document = await FirebaseFirestore.instance
        .collection('createWorkout')
        .doc(widget.docId)
        .get();

    if (document.exists) {
      setState(() {
        var entireExercise = {
          "warmUps": document.get('warmUps'),
          "workouts": document.get('workouts'),
          "coolDowns": document.get('coolDowns'),
          "restTime": document.get('time'),
          "bodyArea": document.get("bodyArea"),
          "displayImage": document.get('displayImage')
        };

        print('entireExercise: $entireExercise'); // Debug print

        workout = document;
        imageUrl = document.get('displayImage');
        difficulty = document.get('difficulty');
        selectedCategories = document.get('selectedCategories');
        bodyArea = document.get('bodyArea');
        description = document.get('description');
        //  time = document.get('time');

        warmUps.addAll(document.get('warmUps'));
        workouts.addAll(document.get('workouts'));
        coolDowns.addAll(document.get('coolDowns'));

        for (var i = 0; i < warmUps.length; i++) {
          int minutes = warmUps[i]['selectedMinutes'] ?? 0;
          int seconds = warmUps[i]['selectedSeconds'] ?? 0;
          String restTime = '$minutes min $seconds sec';

          warmupWidgets.add(
            ExerciseVideoWidget(
              imageUrl: warmUps[i]['image'] ?? 'images/upperBody.png',
              header: warmUps[i]['name']?.toString() ?? 'Warmup',
              info: warmUps[i]['description']?.toString() ?? '',
              docId: widget.docId,
              list: warmUps,
              userType: widget.userType,
              warmupData: warmUps[i],
              entireExercise: entireExercise,
              type: "warmUps",
              restTime: restTime, // Fetch rest time
            ),
          );
        }
        for (var i = 0; i < workouts.length; i++) {
          int minutes = workouts[i]['selectedMinutes'] ?? 0;
          int seconds = workouts[i]['selectedSeconds'] ?? 0;
          String restTime = '$minutes min $seconds sec';

          workoutWidgets.add(
            ExerciseVideoWidget(
              imageUrl: workouts[i]['image'] ?? 'images/upperBody.png',
              header: workouts[i]['name']?.toString() ?? 'Workout',
              info: workouts[i]['description']?.toString() ?? '',
              docId: widget.docId,
              list: workouts,
              userType: widget.userType, // Use widget.userType here
              warmupData: workouts[i],
              entireExercise: entireExercise,
              type: "workouts",
              restTime: restTime,
            ),
          );
        } // For Workouts
        for (var i = 0; i < workouts.length; i++) {
          int minutes = workouts[i]['selectedMinutes'] ?? 0;
          int seconds = workouts[i]['selectedSeconds'] ?? 0;
          String restTime = '$minutes min $seconds sec';

          workoutWidgets.add(
            ExerciseVideoWidget(
              imageUrl: workouts[i]['image'] ?? 'images/upperBody.png',
              header: workouts[i]['name']?.toString() ?? 'Workout',
              info: workouts[i]['description']?.toString() ?? '',
              docId: widget.docId,
              list: workouts,
              userType: widget.userType, // Use widget.userType here
              warmupData: workouts[i],
              entireExercise: entireExercise,
              type: "workouts",
              restTime: restTime,
            ),
          );
        }

// For Cooldowns
        for (var i = 0; i < coolDowns.length; i++) {
          int minutes = coolDowns[i]['selectedMinutes'] ?? 0;
          int seconds = coolDowns[i]['selectedSeconds'] ?? 0;
          String restTime = '$minutes min $seconds sec';

          cooldownWidgets.add(
            ExerciseVideoWidget(
              imageUrl: coolDowns[i]['image'] ?? 'images/upperBody.png',
              header: coolDowns[i]['name']?.toString() ?? 'Cooldown',
              info: coolDowns[i]['description']?.toString() ?? '',
              docId: widget.docId,
              list: coolDowns,
              userType: widget.userType, // Use widget.userType here
              warmupData: coolDowns[i],
              entireExercise: entireExercise,
              type: "coolDowns",
              restTime: restTime,
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    fetchWorkoutDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

/*
    var data = workout!.data() as Map<String, dynamic>;
    var imageUrl = data['displayImage']?.toString() ?? 'images/upperBody.png';
    var difficulty = data['difficulty']?.toString() ?? 'BEGINNER';
    var selectedCategories =
        data['selectedCategories']?.toString() ?? 'AT HOME';
    var bodyArea = data['bodyArea']?.toString() ?? 'Upper Body';
    var description = data['description']?.toString() ?? 'Upper Body';
    var time = data['time']?.toString() ?? '14 min';

    List<Widget> warmupWidgets = (data['warmup'] as List<dynamic>?)
            ?.map((item) => ExerciseVideoWidget(
                  imageUrl:
                      item['warmupImage']?.toString() ?? 'images/upperBody.png',
                  header: item['name']?.toString() ?? 'Warmup',
                  info: item['description']?.toString() ?? '',
                  warmupData: item,
                  docId: widget.docId,
                  list: data['warmup'],
                  userType: 'user',
                ))
            .toList() ??
        [];

    List<Widget> workoutWidgets = (data['workout'] as List<dynamic>?)
            ?.map((item) => ExerciseVideoWidget(
                  imageUrl:
                      item['warmupImage']?.toString() ?? 'images/upperBody.png',
                  header: item['name']?.toString() ?? 'Workout',
                  info: item['description']?.toString() ?? '',
                  warmupData: item,
                  docId: widget.docId,
                  list: data['workout'],
                  userType: 'user',
                ))
            .toList() ??
        [];

    List<Widget> cooldownWidgets = (data['cooldown'] as List<dynamic>?)
            ?.map((item) => ExerciseVideoWidget(
                  imageUrl:
                      item['warmupImage']?.toString() ?? 'images/upperBody.png',
                  header: item['name']?.toString() ?? 'Cool Down',
                  info: item['description']?.toString() ?? '',
                  warmupData: item,
                  docId: widget.docId,
                  list: data['cooldown'],
                  userType: 'user',
                ))
            .toList() ??
        [];
*/
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Bring back the leading icon
        centerTitle: true, // Center the title
        title: Text('Workout Details'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left), // Use the back arrow icon
          onPressed: () {
            // Navigate to BottomNavBar with initialIndex: 0 when tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserState()),
            );
          },
        ),
      ),
      body: MainContainer(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const /*ResultsScreenOne()*/ BottomNavBar(
                            initialIndex: 1)),
              );
            },
            child: DetailContainer(
                assetName: imageUrl,
                difficulty: '$selectedCategories - $difficulty',
                exerciseType: bodyArea,
                duration: '$time minutes',
                kcalAmount: ''),
          ),
          /**/
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkoutCreatorVideoMain()),
                );
              },
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'BeVietnam',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            color: UiColors().grey,
            thickness: 0.2,
            height: 1,
          ),
          Text(
            test,
            style: TextStyle(color: Colors.black),
          ),
          ExerciseDropDown(
            addSectionPress: () {
              // Check the userType before navigating
              if (widget.userType != 'user') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WarmUpCreator(
                            docId: widget.docId,
                            type: 'warmUps',
                            exerciseList: warmUps,
                          )),
                );
              } else {
                // Provide feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'You do not have permission to access this feature.'),
                  ),
                );
              }
            },
            isButtonVisible: widget.userType != "user",
            addSectionText: 'Add Warmup',
            buttonTitle: 'Warm Up',
            dropdownContent: DropDownContent(
              widgets: warmupWidgets,
            ),
            onToggle: () {
              toggleDropdown(1);
            },
            isOpen: currentOpenDropdown == 1,
            iconData: currentOpenDropdown == 1
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
          ),
          ExerciseDropDown(
            addSectionPress: () {
              // Check the userType before navigating
              if (widget.userType != 'user') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WarmUpCreator(
                            docId: widget.docId,
                            type: 'workouts',
                            exerciseList: workouts,
                          )),
                );
              } else {
                // Provide feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'You do not have permission to access this feature.'),
                  ),
                );
              }
            },
            isButtonVisible: widget.userType != "user",
            addSectionText: 'Add Workout',
            buttonTitle: 'Workout',
            dropdownContent: DropDownContent(widgets: workoutWidgets),
            onToggle: () => toggleDropdown(2),
            isOpen: currentOpenDropdown == 2,
            iconData: currentOpenDropdown == 2
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ExerciseDropDown(
              addSectionPress: () {
                // Check the userType before navigating
                if (widget.userType != 'user') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WarmUpCreator(
                              docId: widget.docId,
                              type: 'coolDowns',
                              exerciseList: coolDowns,
                            )),
                  );
                } else {
                  // Provide feedback to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'You do not have permission to access this feature.'),
                    ),
                  );
                }
              },
              isButtonVisible: widget.userType != "user",
              addSectionText: 'Add Cool down',
              buttonTitle: 'Cool Down',
              dropdownContent: DropDownContent(widgets: cooldownWidgets),
              onToggle: () => toggleDropdown(3),
              isOpen: currentOpenDropdown == 3,
              iconData: currentOpenDropdown == 3
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          )
        ],
      ),
    );
  }
}
