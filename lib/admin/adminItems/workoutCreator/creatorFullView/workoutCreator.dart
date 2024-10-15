import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/myCreatorHeaders.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/creatorTextFieldBig.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/creatorTextFieldSmall.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/myTagButtons.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/questionConHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/ui/myTimerSlider.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/videoBrowsPage.dart';

List<String> bodyAreaList = [
  'Full body',
  'Upper body',
  'Cardio & Core',
  'Legs',
];

List<String> difficultyList = [
  'Basic',
  'Intermediate',
  'Tough',
];

List<String> equipmentList = [
  'No Equipment',
  'Dumbbells',
  'Kettlebell',
  'Resistance Bands',
  'Skipping Rope',
  'Step',
  'Mat',
  'Battle Rope',
  'Plyo Box',
  'Fixed Straight Bar',
  'Weighted Barbell',
  'Slam Ball',
  'Airbike',
  'Indoor Rower',
];

/*List<String> restingPeriodList = [
  '1 min',
  '1 min 15 Sec',
  '1 min 30 Sec',
  '2 min',
  '2 min 15 Sec',
];*/

class WorkoutCreator extends StatefulWidget {
  final String documentId;
  final String category;
  final List<String> selectedCategories;
  final String difficulty;
  final List<String> selectedWeekdays;

  const WorkoutCreator({
    required this.documentId,
    required this.category,
    required this.selectedCategories,
    required this.difficulty,
    required this.selectedWeekdays,
    super.key,
  });

  @override
  State<WorkoutCreator> createState() => _WorkoutCreatorState();
}

class _WorkoutCreatorState extends State<WorkoutCreator> {
  final TextEditingController _workoutName = TextEditingController();
  final TextEditingController _workoutDescription = TextEditingController();
  String selectedBodyArea = '';
  List<String> selectedEquipment = [];
  String selectedResting = '';
  double selectedTime = 1;
  String? warmupPhotoUrl;

  bool isLoading = false;

  Future<void> addWorkout() async {
    if (_workoutName.text.isEmpty || _workoutDescription.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('createWorkout')
          .doc(widget.documentId)
          .set({
        'selectedCategories': widget.selectedCategories,
        'difficulty': widget.difficulty,
        'selectedWeekdays': widget.selectedWeekdays,
        'name': _workoutName.text,
        'description': _workoutDescription.text,
        'bodyArea': selectedBodyArea,
        'equipment': selectedEquipment,
        'restingPeriod': selectedResting,
        'time': selectedTime,
        'displayImage': warmupPhotoUrl ?? '',
        'id': widget.documentId,
        "warmUps": [],
        "workouts": [],
        "coolDowns": []
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout added successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideoBrowsPage()),
      );
    } catch (e) {
      print('Error adding workout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add workout. Please try again.')),
      );
    }
  }

  Future<void> _selectAndUploadImage(String imageType) async {
    setState(() {
      isLoading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      String fileName = '${widget.documentId}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('workout_images/$fileName');
      await storageRef.putFile(File(image.path));

      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        warmupPhotoUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$imageType image uploaded successfully')),
      );
    } catch (e) {
      print('Error uploading $imageType image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to upload $imageType image. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/placeHolder1.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: widthDevice * 0.80,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'WORKOUT CREATOR',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyTimeSlider(
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          QuestionConHeader(header: 'WORKOUT CREATOR'),
                          CreatorTextFieldSmall(
                            controller: _workoutName,
                            hintText: 'Workout Name',
                            onChanged: () {},
                          ),
                          CreatorTextFieldBig(
                            controller: _workoutDescription,
                            onChanged: () {},
                            hintText: 'Workout Description',
                          ),
                          MyCreatorHeaders(text: 'Body Area'),
                          Wrap(
                            children: [
                              for (var i = 0; i < bodyAreaList.length; i++)
                                MyTagButtons(
                                  isSelected:
                                      selectedBodyArea == bodyAreaList[i],
                                  onSelected: (tag, isSelected) {
                                    if (isSelected) {
                                      setState(() {
                                        selectedBodyArea = tag;
                                      });
                                    } else if (selectedBodyArea == tag) {
                                      setState(() {
                                        selectedBodyArea = '';
                                      });
                                    }
                                  },
                                  tagText: bodyAreaList[i],
                                ),
                            ],
                          ),
                          MyCreatorHeaders(text: 'Equipment'),
                          Wrap(
                            children: [
                              for (var i = 0; i < equipmentList.length; i++)
                                MyTagButtons(
                                  isSelected: selectedEquipment
                                      .contains(equipmentList[i]),
                                  onSelected: (tag, isSelected) {
                                    setState(() {
                                      if (isSelected) {
                                        if (!selectedEquipment.contains(tag)) {
                                          selectedEquipment.add(tag);
                                        }
                                      } else {
                                        selectedEquipment.remove(tag);
                                      }
                                    });
                                  },
                                  tagText: equipmentList[i],
                                ),
                            ],
                          ),
                          /* MyCreatorHeaders(text: 'Resting Period'),
                          Wrap(
                            children: [
                              for (var i = 0; i < restingPeriodList.length; i++)
                                MyTagButtons(
                                  isSelected:
                                      selectedResting == restingPeriodList[i],
                                  tagText: restingPeriodList[i],
                                  onSelected: (tag, isSelected) {
                                    if (isSelected) {
                                      setState(() {
                                        selectedResting = tag;
                                      });
                                    } else if (selectedResting == tag) {
                                      setState(() {
                                        selectedResting = '';
                                      });
                                    }
                                  },
                                ),
                            ],
                          ),*/
                          const SizedBox(height: 25),
                          MyCreatorHeaders(text: 'Select Display image'),
                          CommonButtons(
                            buttonText: 'Select Image',
                            onTap: () => _selectAndUploadImage('displayPhoto'),
                            buttonColor: AdminColors().lightTeal,
                          ),
                          if (isLoading)
                            Center(child: CircularProgressIndicator()),
                          const SizedBox(height: 10),
                          /*  MyCreatorHeaders(text: 'Workout Photo'),
                          CommonButtons(
                            buttonText: 'Select Image',
                            onTap: () {},
                            buttonColor: AdminColors().lightTeal,
                          ),
                          if (isLoading)
                            Center(child: CircularProgressIndicator()),
                          const SizedBox(height: 10),
                          MyCreatorHeaders(text: 'Select display image'),
                          CommonButtons(
                            buttonText: 'Select Image',
                            onTap: () {},
                            buttonColor: AdminColors().lightTeal,
                          ),
                          if (isLoading)
                            Center(child: CircularProgressIndicator()),*/
                          SizedBox(height: heightDevice * 0.08),
                          MyDivider(),
                          const SizedBox(height: 15),
                          CommonButtons(
                            buttonText: 'Create Workout',
                            onTap: addWorkout,
                            buttonColor: AdminColors().lightBrown,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
