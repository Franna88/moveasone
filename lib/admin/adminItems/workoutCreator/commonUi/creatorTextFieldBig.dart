import 'package:flutter/material.dart';

class CreatorTextFieldBig extends StatefulWidget {
  Function() onChanged;
  final String hintText;
  final TextEditingController controller;

  CreatorTextFieldBig(
      {super.key,
      required this.onChanged,
      required this.hintText,
      required this.controller});

  @override
  State<CreatorTextFieldBig> createState() => _CreatorTextFieldBigState();
}

class _CreatorTextFieldBigState extends State<CreatorTextFieldBig> {
  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    var heightDevice = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: widthDevice * 0.90,
        height: heightDevice * 0.18,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: widget.controller,
            onChanged: (value) => widget.onChanged,
            cursorColor: Colors.black,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(fontWeight: FontWeight.w400),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
