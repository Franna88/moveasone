import 'package:flutter/material.dart';

class CommonButtons extends StatefulWidget {
  final String buttonText;
  Function() onTap;
  final Color buttonColor;
  CommonButtons(
      {super.key,
      required this.buttonText,
      required this.onTap,
      required this.buttonColor});

  @override
  State<CommonButtons> createState() => _CommonButtonsState();
}

class _CommonButtonsState extends State<CommonButtons> {
  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widthDevice,
        decoration: BoxDecoration(
          color: widget.buttonColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              widget.buttonText,
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
