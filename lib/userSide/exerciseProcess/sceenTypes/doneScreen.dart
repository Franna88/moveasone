import 'package:flutter/material.dart';

import '../../../commonUi/navVideoButton.dart';
import '../../../commonUi/uiColors.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Material(
        child: Stack(children: [
      Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/placeHolder1.jpg'),
              fit: BoxFit.fitHeight),
        ),
      ),
      Container(
        color: Colors.black.withOpacity(0.5),
        height: heightDevice,
        width: widthDevice,
      ),
      Container(
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'Well done!',
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Exercise Complete',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: heightDevice * 0.40,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavVideoButton(
                    buttonColor: UiColors().brown,
                    buttonText: 'Finish Workout',
                    onTap: () {
                      //ADD LOGIC
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]));
  }
}
