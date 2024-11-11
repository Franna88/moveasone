import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/myVoiceTimer.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class CreatorVoiceRecord extends StatefulWidget {
  final String audioUrl;

  const CreatorVoiceRecord({super.key, required this.audioUrl});

  @override
  State<CreatorVoiceRecord> createState() => _CreatorVoiceRecordState();
}

class _CreatorVoiceRecordState extends State<CreatorVoiceRecord> {
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
              fit: BoxFit.fitHeight),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CommonOverlayHeader(
                header: 'WARM UP',
                textColor: Colors.white,
              ),
              SizedBox(
                height: heightDevice * 0.05,
              ),
              MyVoiceTimer(
                audioUrl: widget.audioUrl,
              ),
              SizedBox(
                height: heightDevice * 0.05,
              ),
              /*  ContentGlassContainer(
                  workoutName: 'Name here',
                  bodyPart: 'Full Body',
                  topic: 'Peace',
                  content1: 'Remember to breathe',
                  content2: 'Muscle Tension'),*/
              SizedBox(
                height: heightDevice * 0.05,
              ),
              NavVideoButton(
                buttonColor: UiColors().teal,
                buttonText: 'Done',
                onTap: () {
                  //ADD ROUTE
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
