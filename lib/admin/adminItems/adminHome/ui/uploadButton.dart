import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Function() onTap;
  const UploadButton(
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
          width: widthDevice * 0.90,
          color: buttonColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Expanded(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}