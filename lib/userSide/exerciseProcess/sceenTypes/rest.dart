import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../../../commonUi/navVideoButton.dart';
import '../../../commonUi/uiColors.dart';
import '../../../components/timerEdit.dart';

class Rest extends StatefulWidget {
  String imageUrl;
  Function changePageIndex;
  final int time;
  Rest(
      {super.key,
      required this.imageUrl,
      required this.changePageIndex,
      required this.time});

  @override
  State<Rest> createState() => _RestState();
}

class _RestState extends State<Rest> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(children: [
      Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                widget.imageUrl,
              ),
              fit: BoxFit.fitHeight),
        ),
      ),
      Container(
        color: Colors.black.withOpacity(0.5),
        height: heightDevice,
        width: widthDevice,
      ),
      Container(
        height: heightDevice,
        width: widthDevice,
        child: Column(
          children: [
            SizedBox(
              height: heightDevice * 0.05,
            ),
            TimeEdit(
              timeCountDown: widget.time,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rest",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "25 Seconds Rest",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            NavVideoButton(
              buttonColor: UiColors().teal,
              buttonText: 'Next Workout',
              onTap: () {
                widget.changePageIndex();
              },
            ),
            SizedBox(
              height: heightDevice * 0.05,
            ),
          ],
        ),
      )
    ]);
  }
}
