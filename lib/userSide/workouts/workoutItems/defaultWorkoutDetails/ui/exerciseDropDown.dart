import 'package:flutter/material.dart';

class ExerciseDropDown extends StatefulWidget {
  final String buttonTitle;
  final Widget dropdownContent;
  final Function() onToggle;
  final bool isOpen;
  IconData iconData;
  ExerciseDropDown(
      {super.key,
      required this.buttonTitle,
      required this.dropdownContent,
      required this.onToggle,
      required this.isOpen,
      required this.iconData});

  @override
  State<ExerciseDropDown> createState() => _ExerciseDropDownState();
}

class _ExerciseDropDownState extends State<ExerciseDropDown> {
  @override
  Widget build(BuildContext context) {

    
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.buttonTitle,
                  style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'BeVietnam'),
                ),
                Icon(
                  widget.iconData,
                  color: Colors.black,
                  size: 30,
                )
              ],
            ),
          ),
        ),
        if (widget.isOpen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [widget.dropdownContent],),
      ],
    );
  }
}

