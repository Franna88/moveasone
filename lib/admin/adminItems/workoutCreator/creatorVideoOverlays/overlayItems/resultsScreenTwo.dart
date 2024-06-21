import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenThree.dart';
import 'package:move_as_one/commonUi/pauseButtonCon.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/commonUi/circularCountdown.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/workoutCreatorVideo.dart/ui/otherTrainersContainer.dart';

class ResultsScreenTwo extends StatelessWidget {
  const ResultsScreenTwo({super.key});

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
              image: AssetImage('images/placeHolder1.jpg'), fit: BoxFit.cover),
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
                                  'WARM UP',
                                  style: TextStyle(
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
                //SIZE OF TEXT SHOULD INCREASE WHEN ACTIVE
                Text(
                  'Start',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Proper Form And Setup',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 15,),
                    //VIDEO/VOICE DURATION
                    Text(
                      '30 sec',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Upper Body',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 15,),
                    //VIDEO/VOICE DURATION
                    Text(
                      '45 sec',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OtherTrainersContainer(),
                    SizedBox(width: widthDevice * 0.15,),
                    GestureDetector(onTap: () {
                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResultsScreenTree()),
  );
                    },child: PauseButtonCon())
                  ],
                ),
                SizedBox(
                  height: heightDevice * 0.06,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
