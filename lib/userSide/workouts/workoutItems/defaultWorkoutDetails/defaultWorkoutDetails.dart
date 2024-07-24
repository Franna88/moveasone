import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/warmUpCreator.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenOne.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/deatilContainer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/dropDownContent.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/exerciseDropDown.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/ui/exerciseVideoWidget.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/workoutCreatorVideoMain.dart';

class DefaultWorkoutDetails extends StatefulWidget {
  final String docId;
  const DefaultWorkoutDetails({super.key, required this.docId});

  @override
  State<DefaultWorkoutDetails> createState() => _DefaultWorkoutDetailsState();
}

class _DefaultWorkoutDetailsState extends State<DefaultWorkoutDetails> {
  bool isDroped = false;
  bool isActive = false;
  int? currentOpenDropdown;
  DocumentSnapshot? workout;

  @override
  void initState() {
    super.initState();
    fetchWorkoutDetails();
  }

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
    setState(() {
      workout = document;
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Workout Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var data = workout!.data() as Map<String, dynamic>;
    var imageUrl = data['warmupPhoto']?.toString() ?? 'images/upperBody.png';
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
                list: data['warmup']))
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
                list: data['workout']))
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
                list: data['cooldown']))
            .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
      ),
      body: MainContainer(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResultsScreenOne()),
              );
            },
            child: DetailContainer(
                assetName: imageUrl,
                difficulty: '$selectedCategories - $difficulty',
                exerciseType: bodyArea,
                duration: '$time minutes',
                kcalAmount: ''),
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
          ExerciseDropDown(
            addSectionPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WarmUpCreator(
                          docId: widget.docId,
                          type: 'warmup',
                          exerciseList: [],
                        )),
              );
            },
            addSectionText: 'Add Warmup',
            buttonTitle: 'Warm Up',
            dropdownContent: DropDownContent(
              widgets: warmupWidgets.isNotEmpty
                  ? warmupWidgets
                  : [
                      ExerciseVideoWidget(
                          imageUrl: 'images/upperBody.png',
                          header: 'Default Warmup',
                          info: 'No warmup added yet.',
                          docId: '',
                          warmupData: {},
                          list: data['warmup'])
                    ],
            ),
            onToggle: () {
              toggleDropdown(1);
            },
            isOpen: currentOpenDropdown == 1,
            iconData:
                isDroped ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
          ExerciseDropDown(
            addSectionPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WarmUpCreator(
                          docId: widget.docId,
                          type: 'workout',
                          exerciseList: [],
                        )),
              );
            },
            addSectionText: 'Add Workout',
            buttonTitle: 'Workout',
            dropdownContent: DropDownContent(
              widgets: workoutWidgets.isNotEmpty
                  ? workoutWidgets
                  : [
                      ExerciseVideoWidget(
                          imageUrl: 'images/upperBody.png',
                          header: 'Default Workout',
                          info: 'No workout added yet.',
                          docId: '',
                          warmupData: {},
                          list: data['warmup'])
                    ],
            ),
            onToggle: () => toggleDropdown(2),
            isOpen: currentOpenDropdown == 2,
            iconData:
                isDroped ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
          ExerciseDropDown(
            addSectionPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WarmUpCreator(
                          docId: widget.docId,
                          type: 'cooldown',
                          exerciseList: [],
                        )),
              );
            },
            addSectionText: 'Add Cool down',
            buttonTitle: 'Cool Down',
            dropdownContent: DropDownContent(
              widgets: cooldownWidgets.isNotEmpty
                  ? cooldownWidgets
                  : [
                      ExerciseVideoWidget(
                          imageUrl: 'images/upperBody.png',
                          header: 'Default Cool Down',
                          info: 'No cool down added yet.',
                          docId: '',
                          warmupData: {},
                          list: data['warmup'])
                    ],
            ),
            onToggle: () => toggleDropdown(3),
            isOpen: currentOpenDropdown == 3,
            iconData:
                isDroped ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          )
        ],
      ),
    );
  }
}
