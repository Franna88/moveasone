import 'package:flutter/material.dart';

class AnswersEditTextfield extends StatelessWidget {
  final String hintText;
  const AnswersEditTextfield({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: const Color.fromARGB(0, 0, 0, 0),
        borderRadius: BorderRadius.circular(10),
        elevation: 6,
        child: Container(
          width: widthDevice * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: TextField(
            minLines: 1,
            maxLines: 5,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
