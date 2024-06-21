import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/mainContentContainer.dart';

class ProfileEditTextField extends StatelessWidget {
  final String labelText;
  Function() onChanged;
  final double fieldWidth;
  final Color textColor;
  final TextInputType keyType;

  ProfileEditTextField(
      {super.key,
      required this.labelText,
      required this.fieldWidth,
      required this.onChanged,
      required this.textColor, required this.keyType});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: fieldWidth,
          decoration: BoxDecoration(
            border: Border.all(width: 0.1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 187, 187, 187),
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                style: TextStyle(color: textColor, fontFamily: 'BeVietnam',),
                onChanged: (value) => onChanged,
                cursorColor: Colors.black,
                maxLines: 5,
                minLines: 1,
                keyboardType: keyType,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  border: InputBorder.none,
                  labelText: labelText,
                  
                  labelStyle: TextStyle(
                    fontFamily: 'BeVietnam',
                    fontSize: 14,
                    color: UiColors().textgrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
