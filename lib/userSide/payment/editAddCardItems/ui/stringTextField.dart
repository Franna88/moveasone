import 'package:flutter/material.dart';

class StringTextField extends StatelessWidget {
  final String labelText;
  Function() onChanged;
  StringTextField(
      {super.key, required this.labelText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: TextField(
          onChanged: (value) => onChanged,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: InputBorder.none,
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
           
          ),
        ),
      ),
    );
  }
}
