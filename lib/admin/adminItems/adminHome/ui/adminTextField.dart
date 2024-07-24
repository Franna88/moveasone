import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController
      controller; // Step 1: Declare TextEditingController
  final int maxLength; // Add a maxLength parameter

  const AdminTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.maxLength = 100, // Set a default value for maxLength if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 0.2,
        ),
      ),
      child: TextField(
        controller: controller, // Step 2: Pass the TextEditingController
        minLines: 1,
        maxLines: 5,
        cursorColor: Colors.black,
        maxLength: maxLength, // Set the maxLength
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w400),
          counterText: "", // Optionally, hide the counter text
        ),
      ),
    );
  }
}
