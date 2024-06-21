import 'package:flutter/material.dart';

class NumberTextField extends StatelessWidget {
  final String labelText;
  Function() onChanged;
  final double fieldWidth;

  NumberTextField(
      {super.key,
      required this.labelText,
      required this.fieldWidth,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: fieldWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: TextField(
          onChanged: (value) => onChanged,
          keyboardType: TextInputType.number,
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
