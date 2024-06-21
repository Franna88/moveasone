import 'package:flutter/material.dart';
import 'package:move_as_one/MyHome.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workoutPopups/ui/awardedToText.dart';

class AwardEmojiPopUp extends StatelessWidget {
  const AwardEmojiPopUp({super.key});

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
            colorFilter: ColorFilter.mode(
                Color.fromARGB(151, 0, 0, 0), BlendMode.colorBurn),
            image: AssetImage('images/commonImg.png'),
            fit: BoxFit.cover,
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
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
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
              ),
              SizedBox(
                height: heightDevice * 0.20,
              ),
              Text(
                'Well done!',
                style: TextStyle(
                  fontFamily: 'BeVietnam',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),

              //EMOJI AND NAME OF USER
              AwardedToText(awardedTo: 'Hi-Five was awarded to Anika Mango'),
              SizedBox(
                height: heightDevice * 0.06,
              ),
              Material(
                elevation: 10,
                color: const Color.fromARGB(0, 255, 255, 255),
                shape: CircleBorder(),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: const Color.fromARGB(113, 255, 255, 255),
                  ),
                  child: Image.asset('images/hiFive.png'),
                ),
              ),

              Spacer(),
              NavVideoButton(
                  buttonColor: UiColors().teal,
                  buttonText: 'Done',
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHome()),
                  );
                    //ADD LOGIC HERE
                  }),
              SizedBox(
                height: heightDevice * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
