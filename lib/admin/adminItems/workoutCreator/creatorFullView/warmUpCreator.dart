import 'dart:io';
import 'package:uuid/uuid.dart';
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
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorVoiceRecord.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorWorkoutCompleted.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';

List<String> topicsList = [
  'Peace',
  'Radiance',
  'Strength',
  'Love',
  'Joy',
  'Creative',
];
List<String> warmupDifficultyList = [
  'Basic',
  'Intermediate',
  'Tough',
];
List<String> warmUpEquipmentList = [
  'No equipment',
  'Dumbells',
  'Kettlebell',
  'Resistance Bands',
];

class WarmUpCreator extends StatefulWidget {
  final String docId;
  final String type;
  final Map<String, dynamic>? warmupData;
  final List exerciseList;

  const WarmUpCreator(
      {Key? key,
      required this.docId,
      required this.type,
      this.warmupData,
      required this.exerciseList})
      : super(key: key);

  @override
  State<WarmUpCreator> createState() => _WarmUpCreatorState();
}

class _WarmUpCreatorState extends State<WarmUpCreator> {
  final TextEditingController _warmupName = TextEditingController();
  final TextEditingController _warmupDescription = TextEditingController();
  double selectedTime = 1.0;

  String selectedTopic = '';
  String selectedDifficulty = '';
  String selectedEquipment = '';

  String? imageUrl;
  String? videoUrl;
  bool isLoading = false;
  var itemId = 0;

  @override
  void initState() {
    super.initState();
    if (widget.warmupData != null) {
      _warmupName.text = widget.warmupData!['name'] ?? '';
      _warmupDescription.text = widget.warmupData!['description'] ?? '';
      //selectedTime = widget.warmupData!['time'] ?? 1.0;
      selectedTopic = widget.warmupData!['topic'] ?? '';
      selectedDifficulty = widget.warmupData!['difficulty'] ?? '';
      selectedEquipment = widget.warmupData!['equipment'] ?? '';
      imageUrl = widget.warmupData!['warmupImage'];
      videoUrl = widget.warmupData!['videoUrl'];
    }
  }

  Future<void> _addWarmupToFirestore() async {
    setState(() {
      isLoading = true;
    });

    String docId = widget.docId;
    var uuid = Uuid();
    itemId =
        widget.warmupData != null ? widget.warmupData!['itemId'] : uuid.v1();

    // Create a new warmup item
    Map<String, dynamic> newItem = {
      'itemId': itemId,
      'name': 'test',
      'description': _warmupDescription.text,
      'time': 10,
      'topic': selectedTopic,
      'difficulty': selectedDifficulty,
      'equipment': selectedEquipment,
      'warmupImage': imageUrl,
      'videoUrl': videoUrl,
    };

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('createWorkout').doc(docId);

    try {
      if (widget.warmupData != null) {
        // Editing existing warmup
        /*final docSnapshot = await docRef.get();
        final data = docSnapshot.data() as Map<String, dynamic>;*/

        /* // Retrieve and update the list of warmups
        List<dynamic> warmups = List.from(data[widget.type] as List<dynamic>);
        warmups.remove(widget.warmupData); // Remove the old warmup data
        warmups.add(newItem); // Add the updated warmup data

        await docRef.update({
          widget.type: warmups, // Update the warmups list in Firestore
        });*/
        /*var exerciseindex = (widget.exerciseList)
            .indexWhere((item) => item["itemId"] == itemId);
        widget.exerciseList.remove(exerciseindex);
        widget.exerciseList.insert(exerciseindex, newItem);*/
        //docRef.update({'workout': widget.exerciseList});
      } else {
        // Adding new warmup
        await docRef.update({
          widget.type: FieldValue.arrayUnion([newItem]),
        });
      }

      print(
          "${widget.type} ${widget.warmupData != null ? 'updated' : 'added'} successfully.");
    } catch (e) {
      print('Error updating Firestore: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
      String fileName = '${widget.docId}_${imageType}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('workout_images/$fileName');
      await storageRef.putFile(File(image.path));

      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
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

  Future<void> _selectAndUploadVideo() async {
    setState(() {
      isLoading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      String fileName = '${widget.docId}.mp4';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('workout_videos/$fileName');
      await storageRef.putFile(File(video.path));

      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        videoUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreatorWorkoutCompleted(videoUrl: videoUrl!),
        ),
      );
    } catch (e) {
      print('Error uploading video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload video. Please try again.')),
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
                    const SizedBox(
                      width: 15,
                    ),
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
                          'WARMUP CREATOR',
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
                          QuestionConHeader(header: 'WARMUP CREATOR'),
                          CreatorTextFieldSmall(
                            controller: _warmupName,
                            hintText: 'Warmup Title',
                            onChanged: () {
                              // ADD LOGIC HERE
                            },
                          ),
                          CreatorTextFieldBig(
                            controller: _warmupDescription,
                            onChanged: () {
                              // ADD LOGIC HERE
                            },
                            hintText: 'Content',
                          ),
                          MyCreatorHeaders(text: 'Topics'),
                          Wrap(
                            children: [
                              for (var i = 0; i < topicsList.length; i++)
                                MyTagButtons(
                                  tagText: topicsList[i],
                                  onSelected:
                                      (String tagText, bool isSelected) {
                                    setState(() {
                                      selectedTopic = tagText;
                                    });
                                  },
                                  isSelected: selectedTopic == topicsList[i],
                                ),
                            ],
                          ),
                          MyCreatorHeaders(text: 'Difficulty'),
                          Wrap(
                            children: [
                              for (var i = 0;
                                  i < warmupDifficultyList.length;
                                  i++)
                                MyTagButtons(
                                  tagText: warmupDifficultyList[i],
                                  onSelected:
                                      (String tagText, bool isSelected) {
                                    setState(() {
                                      selectedDifficulty = tagText;
                                    });
                                  },
                                  isSelected: selectedDifficulty ==
                                      warmupDifficultyList[i],
                                ),
                            ],
                          ),
                          MyCreatorHeaders(text: 'Equipment'),
                          Wrap(
                            children: [
                              for (var i = 0;
                                  i < warmUpEquipmentList.length;
                                  i++)
                                MyTagButtons(
                                  tagText: warmUpEquipmentList[i],
                                  onSelected:
                                      (String tagText, bool isSelected) {
                                    setState(() {
                                      selectedEquipment = tagText;
                                    });
                                  },
                                  isSelected: selectedEquipment ==
                                      warmUpEquipmentList[i],
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          CommonButtons(
                            buttonText: 'Select Image',
                            onTap: () => _selectAndUploadImage('warmupImage'),
                            buttonColor: AdminColors().lightTeal,
                          ),
                          if (isLoading)
                            Center(child: CircularProgressIndicator()),
                          const SizedBox(
                            height: 25,
                          ),
                          CommonButtons(
                            buttonText: 'Upload Media',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreatorVoiceRecord(
                                    docId: '',
                                  ),
                                ),
                              );
                            },
                            buttonColor: AdminColors().lightTeal,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          CommonButtons(
                            buttonText: 'Upload video',
                            onTap: _selectAndUploadVideo,
                            buttonColor: AdminColors().lightTeal,
                          ),
                          SizedBox(height: heightDevice * 0.08),
                          MyDivider(),
                          const SizedBox(
                            height: 15,
                          ),
                          MyDivider(),
                          const SizedBox(
                            height: 15,
                          ),
                          CommonButtons(
                            buttonText: widget.warmupData != null
                                ? 'Update'
                                : 'Create Warmup',
                            onTap: () {
                              _addWarmupToFirestore().then((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DefaultWorkoutDetails(
                                      docId: widget.docId,
                                    ),
                                  ),
                                );
                              });
                            },
                            buttonColor: AdminColors().lightBrown,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
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
