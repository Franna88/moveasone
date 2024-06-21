import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenOne.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/deatilContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/dropDownContent.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/exerciseDropDown.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/exerciseVideoWidget.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/workoutDescriptionText.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/workoutCreatorVideoMain.dart';

class DefaultWorkoutDetails extends StatefulWidget {
  const DefaultWorkoutDetails({super.key});

  @override
  State<DefaultWorkoutDetails> createState() => _DefaultWorkoutDetailsState();
}

class _DefaultWorkoutDetailsState extends State<DefaultWorkoutDetails> {
  bool isDroped = false;
  bool isActive = false;
  int? currentOpenDropdown;

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

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ResultsScreenOne()),
            );
          },
          child: DetailContainer(
              assetName: 'images/upperBody.png',
              difficulty: 'BEGINNER',
              exerciseType: 'Upper Body',
              duration: '14 min, ',
              kcalAmount: '128 kcal'),
        ),
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
              WorkoutDescriptionText().description1,
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
        ExerciseDropDown(
          buttonTitle: 'Warm Up',
          dropdownContent: DropDownContent(
            widget1: ExerciseVideoWidget(
              assetName: 'images/upperBody.png',
              header: 'Proper Form and Setup',
              info: '30 sec',
            ),
            widget2: ExerciseVideoWidget(
              assetName: 'images/plank.png',
              header: 'Proper Form and Setup',
              info: '30 sec',
            ),
          ),
          onToggle: () {
            toggleDropdown(1);
          },
          isOpen: currentOpenDropdown == 1,
          iconData:
              isDroped ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        ExerciseDropDown(
          buttonTitle: 'Workout',
          dropdownContent: DropDownContent(
            widget1: ExerciseVideoWidget(
              assetName: 'images/placeholder3.jpg',
              header: 'Proper Form and Setup',
              info: '30 sec',
            ),
            widget2: ExerciseVideoWidget(
              assetName: 'images/plank.png',
              header: 'Proper Form and Setup',
              info: '30 sec',
            ),
          ),
          onToggle: () => toggleDropdown(2),
          isOpen: currentOpenDropdown == 2,
          iconData:
              isDroped ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        ExerciseDropDown(
          buttonTitle: 'Cool Down',
          dropdownContent: DropDownContent(
            widget1: ExerciseVideoWidget(
              assetName: 'images/placeholder3.jpg',
              header: 'Proper Form and Setup',
              info: '30 sec',
            ),
            widget2: ExerciseVideoWidget(
              assetName: 'images/plank.png',
              header: 'Proper Form and Setup',
              info: '30 sec',
            ),
          ),
          onToggle: () => toggleDropdown(3),
          isOpen: currentOpenDropdown == 3,
          iconData:
              isDroped ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        )
      ],
    );
  }
}
