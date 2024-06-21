import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/pauseButtonCon.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/commonUi/circularCountdown.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/completedVideoOverlay.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/ui/otherTrainersContainer.dart';

class WorkoutCreatorVideoMain extends StatelessWidget {
  const WorkoutCreatorVideoMain({super.key});

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
              image: AssetImage('images/video10.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TIMER APEARS DURING REST AND WARMUP THE DISSAPEARS WHEN DONE
                /*Center(
                    child: CircularCountdown(),
                  ),*/
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: widthDevice * 0.80,
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'REST',
                                  style: TextStyle(
                                    fontFamily: 'BeVietnam',
                                      fontSize: 16,
                                      color: UiColors().teal,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: CircularCountdown(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  'Rep 3/3',
                  style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'BeVietnam'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'BackWards lunges 3x10 per leg',
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: heightDevice * 0.06,
                ),
                Row(
                  children: [
                    OtherTrainersContainer(),
                    SizedBox(
                      width: widthDevice * 0.20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CompletedVideoOverlay()),
                          );
                        },
                        child: PauseButtonCon())
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
