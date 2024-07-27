import 'package:flutter/material.dart';

import '../../../admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import '../../../admin/adminItems/workoutCreator/creatorVideoOverlays/ui/myVoiceTimer.dart';
import '../../../commonUi/navVideoButton.dart';
import '../../../commonUi/uiColors.dart';

class AudioScreen extends StatefulWidget {
  Function changePageIndex;
  String imageUrl;
  String audioUrl;
  String workoutType;
  String title;
  String description;
  String reps;
  int repsCounter;
  AudioScreen(
      {super.key,
      required this.changePageIndex,
      required this.audioUrl,
      required this.imageUrl,
      required this.workoutType,
      required this.title,
      required this.description,
      required this.reps,
      required this.repsCounter});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          height: heightDevice,
          width: widthDevice,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  widget.imageUrl,
                ),
                fit: BoxFit.fitHeight),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
          height: heightDevice,
          width: widthDevice,
        ),
        Container(
          child: SafeArea(
            child: Column(
              children: [
                CommonOverlayHeader(
                  header: widget.workoutType == "warmUp"
                      ? 'WARMUP'
                      : widget.workoutType == "workouts"
                          ? "WORKOUT"
                          : "COOLDOWN",
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: heightDevice * 0.05,
                ),
                MyVoiceTimer(audioUrl: widget.audioUrl),
                Text(
                  textAlign: TextAlign.start,
                  "Reps ${widget.repsCounter}  / ${widget.reps}",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: heightDevice * 0.05,
                ),
                NavVideoButton(
                  buttonColor: UiColors().teal,
                  buttonText: 'Next Workout',
                  onTap: () {
                    widget.changePageIndex();
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
