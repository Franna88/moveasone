import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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

import '../../../../components/videoView.dart';
import '../creatorVideoOverlays/ui/myVoiceTimer.dart';

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
  final TextEditingController _repetition = TextEditingController();
  final TextEditingController _warmupDescription = TextEditingController();
  double selectedTime = 1.0;

  String selectedTopic = '';
  String selectedDifficulty = '';
  String selectedEquipment = '';

  String imageUrl = "";
  String videoUrl = "";
  String audioUrl = "";
  bool isLoading = false;
  var itemId = "";

//Set var states
  getWarmupDetails() {}

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
      imageUrl = widget.warmupData!['image'];
      videoUrl = widget.warmupData!['videoUrl'];
      _repetition.text = widget.warmupData!['repetition'];
      audioUrl = widget.warmupData!['audioUrl'];
    }
  }

  Future<void> _addWarmupToFirestore() async {
    setState(() {
      isLoading = true;
    });

    String docId = widget.docId;
    var uuid = Uuid();
    itemId = widget.warmupData != null
        ? widget.warmupData!['itemId']
        : uuid.v1().toString(); /**/

    // Create a new warmup item
    Map<String, dynamic> newItem = {
      'itemId': itemId,
      'repetition': _repetition.text,
      'name': _warmupName.text,
      'description': _warmupDescription.text,
      'time': selectedTime,
      'topic': selectedTopic,
      'difficulty': selectedDifficulty,
      'equipment': selectedEquipment,
      'image': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl
    };

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('createWorkout').doc(docId);

    if (widget.warmupData != null) {
      //Edit

      setState(() async {
        var findExerciseIndex = (widget.exerciseList)
            .indexWhere((item) => item["itemId"] == itemId);

        await widget.exerciseList.removeAt(findExerciseIndex);
        widget.exerciseList.insert(findExerciseIndex, newItem);

        print(findExerciseIndex);
        print(widget.exerciseList);

        docRef.update({widget.type: widget.exerciseList}).whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DefaultWorkoutDetails(
                docId: widget.docId,
                userType: '',
              ),
            ),
          );
        });
        ;
      });
    } else {
      //Add
      setState(() {
        widget.exerciseList.add(newItem);
      });
      docRef.update({widget.type: widget.exerciseList}).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DefaultWorkoutDetails(
              docId: widget.docId,
              userType: '',
            ),
          ),
        );
      });
    }
  }

  Future<void> _selectAndUploadImage(String imageType) async {
    setState(() {
      isLoading = true;
    });
    Uint8List webImage = Uint8List(8);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      var f = await image.readAsBytes();
      setState(() {
        webImage = f;
      });
    }
    var uuid = Uuid();
    final ref = FirebaseStorage.instance
        .ref()
        .child('workout_images')
        .child("${uuid.v1()}.png");
    await ref.putData(webImage);
    imageUrl = await ref.getDownloadURL().whenComplete(() {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$imageType image uploaded successfully')),
      );
    });
    final String downloadUrl = imageUrl.toString();
    setState(() {
      imageUrl = downloadUrl;
    });
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
        audioUrl = "";
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

  PlatformFile? pickedFile;

  Future<void> _selectAndUploadAudio() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
      isLoading = true;
    });

    try {
      final path = '${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      Reference storageRef =
          FirebaseStorage.instance.ref().child('workout_audio/$path');
      await storageRef.putFile(file);

      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        // imageUrl = downloadUrl;
        audioUrl = downloadUrl;
        videoUrl = "";
        isLoading = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatorVoiceRecord(
              audioUrl: downloadUrl,
            ),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File uploaded successfully')),
      );
    } catch (e) {
      print('Error uploading file $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload filee. Please try again.')),
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
                          widget.type == "warmUps"
                              ? 'WARMUP CREATOR'
                              : widget.type == "workouts"
                                  ? "WORKOUT CREATOR"
                                  : "COOLDOWN CREATOR",
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
                          QuestionConHeader(
                            header: widget.type == "warmUps"
                                ? 'WARMUP CREATOR'
                                : widget.type == "workouts"
                                    ? "WORKOUT CREATOR"
                                    : "COOLDOWN CREATOR",
                          ),
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
                          CreatorTextFieldSmall(
                            controller: _repetition,
                            hintText: 'Repetitions',
                            onChanged: () {
                              // ADD LOGIC HERE
                            },
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
                          Visibility(
                            visible: imageUrl != "" ? true : false,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: heightDevice * 0.25,
                                  width: widthDevice * 0.35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isLoading)
                            Center(child: CircularProgressIndicator()),
                          const SizedBox(
                            height: 25,
                          ),
                          CommonButtons(
                            buttonText: 'Upload Audio',
                            onTap: () {
                              _selectAndUploadAudio();
                            },
                            buttonColor: AdminColors().lightTeal,
                          ),
                          Visibility(
                              visible: audioUrl != "" ? true : false,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyVoiceTimer(
                                  audioUrl: audioUrl,
                                  customHeight: 25,
                                ),
                              )),
                          const SizedBox(
                            height: 25,
                          ),
                          CommonButtons(
                            buttonText: 'Upload video',
                            onTap: _selectAndUploadVideo,
                            buttonColor: AdminColors().lightTeal,
                          ),
                          Visibility(
                            visible: videoUrl != "" ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: VideoView(
                                  videoUrl: videoUrl,
                                ),
                              ),
                            ),
                          ),
                          /**/
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
                              _addWarmupToFirestore();

                              /*  .then((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DefaultWorkoutDetails(
                                      docId: widget.docId,
                                      userType: '',
                                    ),
                                  ),
                                );
                              });*/
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
