import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorVideoRecord.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class CreatorWarmupComplete extends StatelessWidget {
  const CreatorWarmupComplete({super.key});

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
                  header: 'WARM UP', textColor: UiColors().teal),
              SizedBox(
                height: heightDevice * 0.20,
              ),
              Text(
                'Well done!',
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Warmup Complete.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: heightDevice * 0.40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavVideoButton(
                    buttonColor: UiColors().teal,
                    buttonText: 'Listen',
                    onTap: () {
                      //ADD LOGIC
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  NavVideoButton(
                    buttonColor: UiColors().teal,
                    buttonText: 'To Workout',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatorVideoRecord()),
                      );
                      //ADD ROUTE
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavVideoButton(
                    buttonColor: UiColors().brown,
                    buttonText: 'Record Again',
                    onTap: () {
                      //ADD LOGIC
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  NavVideoButton(
                    buttonColor: UiColors().brown,
                    buttonText: 'Cancel',
                    onTap: () {
                      //ADD LOGIC
                    },
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
