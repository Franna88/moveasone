import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/ui/commonOverlayHeader.dart';
import 'package:move_as_one/commonUi/circularCountdown.dart';
import 'package:move_as_one/commonUi/navVideoButton.dart';
import 'package:move_as_one/commonUi/pauseButtonCon.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class ResultsScreenTree extends StatelessWidget {
  const ResultsScreenTree({super.key});

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
                header: 'COOL DOWN',
                textColor: Colors.white,
              ),
              SizedBox(
                height: heightDevice * 0.02,
              ),
              CircularCountdown(),
              SizedBox(
                height: heightDevice * 0.49,
              ),
              
              PauseButtonCon(),
              Spacer(),
              NavVideoButton(
                buttonColor: UiColors().teal,
                buttonText: 'Done',
                onTap: () {
                  //ADD ROUTE
                  
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

