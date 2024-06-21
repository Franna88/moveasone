import 'package:flutter/material.dart';
import 'package:move_as_one/MyHome.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';

class CompletedVideoOverlay extends StatelessWidget {
  const CompletedVideoOverlay({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        Container(
                          width: widthDevice * 0.80,
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              'WARM UP',
                              style: TextStyle(
                                fontFamily: 'BeVietnam',
                                  fontSize: 16,
                                  color: UiColors().teal,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  'Well done!',
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Your warmup has been completed.',
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'I knew you could do it',
                  style:
                      TextStyle(fontFamily: 'BeVietnam',color: Colors.white, fontSize: 16, height: 1),
                ),
                SizedBox(
                  height: heightDevice * 0.08,
                ),
                NavVideoButton(
                    buttonColor: UiColors().teal,
                    buttonText: 'Next Exercise',
                    onTap: () {}),
                SizedBox(
                  height: heightDevice * 0.25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavVideoButton(
                        buttonColor: UiColors().brown,
                        buttonText: 'Redo Exercise',
                        onTap: () {}),
                    NavVideoButton(
                        buttonColor: UiColors().brown,
                        buttonText: 'Back to Menu',
                        onTap: () {
                          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyHome()),
  );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
