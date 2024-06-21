import 'package:flutter/material.dart';

class MyTagButtons extends StatefulWidget {
  final String tagText;
  const MyTagButtons({super.key, required this.tagText});

  @override
  State<MyTagButtons> createState() => _MyTagButtonsState();
}

bool isSelected = false;

class _MyTagButtonsState extends State<MyTagButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 15),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(48, 166, 74, 219) 
                : Colors.white,
            border: Border.all(
              width: 0.8,
              color: isSelected ? Color.fromARGB(255, 166, 74, 219) : Colors.black,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              widget.tagText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: isSelected ? Color.fromARGB(255, 166, 74, 219) : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
