import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenTwo.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/contentGlassContainer.dart';
import 'package:move_as_one/commonUi/circularCountdown.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/pauseButtonCon.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class ResultsScreenOne extends StatelessWidget {
  const ResultsScreenOne({super.key});

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
                height: heightDevice * 0.02,
              ),
              CircularCountdown(),
              SizedBox(
                height: heightDevice * 0.20,
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
              PauseButtonCon(),
              Spacer(),
              NavVideoButton(
                buttonColor: UiColors().teal,
                buttonText: 'Done',
                onTap: () {
                  //ADD ROUTE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResultsScreenTwo(
                              videoUrl: '',
                            )),
                  );
                },
              ),
              SizedBox(
                height: heightDevice * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
