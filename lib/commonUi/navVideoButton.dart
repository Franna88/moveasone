import 'package:flutter/material.dart';

class NavVideoButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Function() onTap;
  const NavVideoButton(
      {super.key,
      required this.buttonColor,
      required this.buttonText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.circular(15),
        child: Container(
          width: widthDevice * 0.40,
          color: buttonColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                maxLines: 2,
                buttonText,
                style: TextStyle(
                  fontFamily: 'BeVietnam',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
