import 'package:flutter/material.dart';

class CommonButtons extends StatelessWidget {
  final String buttonText;
  Function() onTap;
  final Color buttonColor;
  CommonButtons(
      {super.key,
      required this.buttonText,
      required this.onTap,
      required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widthDevice ,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'BeVietnam',
                //fontWeight: FontWeight.w100
              ),
            ),
          ),
        ),
      ),
    );
  }
}
