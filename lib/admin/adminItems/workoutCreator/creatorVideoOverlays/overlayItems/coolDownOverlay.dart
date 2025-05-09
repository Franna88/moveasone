import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/contentGlassContainer.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/myVoiceTimer.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';

class CoolDownOverlay extends StatelessWidget {
  const CoolDownOverlay({super.key});

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
                header: 'COOLDOWN',
                textColor: Colors.white,
              ),
              SizedBox(
                height: heightDevice * 0.05,
              ),
              MyVoiceTimer(
                audioUrl: '',
              ),
              SizedBox(
                height: heightDevice * 0.05,
              ),
              ContentGlassContainer(
                  workoutName: 'Name here',
                  bodyPart: 'Full Body',
                  topic: 'Peace',
                  content1: 'Remember to breathe',
                  content2: 'Muscle Tension'),
              SizedBox(
                height: heightDevice * 0.05,
              ),
              NavVideoButton(
                buttonColor: UiColors().teal,
                buttonText: 'Done',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DefaultWorkoutDetails(
                              docId: '',
                              userType: '',
                            )),
                  );
                  //ADD ROUTE
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
