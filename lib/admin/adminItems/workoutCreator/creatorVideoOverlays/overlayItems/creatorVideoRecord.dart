import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorWorkoutCompleted.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/bottomVideoBlurCon.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/videoBottomButtons.dart';

class CreatorVideoRecord extends StatelessWidget {
  const CreatorVideoRecord({super.key});

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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: heightDevice * 0.08,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Container(
                    height: heightDevice * 0.12,
                    width: widthDevice * 0.26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('images/placeHolder4.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Spacer(),
              BottomVideoBlurCon(
                children: [
                  VideoBottomButtons(
                    buttonText: 'Effects',
                    icon: Icons.light_mode,
                  ),
                  VideoBottomButtons(
                    buttonText: 'Mute',
                    icon: Icons.mic_off,
                  ),
                  VideoBottomButtons(
                    buttonText: 'Flip',
                    icon: Icons.flip_camera_ios,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatorWorkoutCompleted(
                                  videoUrl: '',
                                )),
                      );
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
