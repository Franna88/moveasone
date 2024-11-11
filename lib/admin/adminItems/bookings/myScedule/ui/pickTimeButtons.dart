import 'package:flutter/material.dart';

class PickTimeButtons extends StatefulWidget {
  final String time;
  PickTimeButtons({
    super.key,
    required this.time,
  });

  @override
  State<PickTimeButtons> createState() => _PickTimeButtonsState();
}

class _PickTimeButtonsState extends State<PickTimeButtons> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          width: widthDevice * 0.20,
          decoration: ShapeDecoration(
            color: isSelected
                ? Color(0xFF006261)
                : const Color.fromARGB(0, 255, 255, 255),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFF006261),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.time,
                style: TextStyle(
                  color: isSelected
                      ? Color.fromARGB(255, 241, 235, 243)
                      : Color(0xFF006261),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
