import 'package:flutter/material.dart';

class ExerciseDropDown extends StatefulWidget {
  final String buttonTitle;
  final Widget dropdownContent;
  final Function() onToggle;
  final bool isOpen;
  IconData iconData;
  final VoidCallback addSectionPress;
  final String addSectionText;

  ExerciseDropDown(
      {super.key,
      required this.buttonTitle,
      required this.dropdownContent,
      required this.onToggle,
      required this.isOpen,
      required this.iconData,
      required this.addSectionPress,
      required this.addSectionText});

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
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'BeVietnam'),
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
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: widget.addSectionPress,
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFAA5F3A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      child: Text(
                        widget.addSectionText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0.10,
                        ),
                      )),
                ),
              ),
              widget.dropdownContent
            ],
          ),
      ],
    );
  }
}
