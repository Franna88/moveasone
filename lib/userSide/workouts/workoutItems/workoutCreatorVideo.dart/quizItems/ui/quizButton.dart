import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class QuizButton extends StatefulWidget {
  final String answer;
  Function() onTap;
  QuizButton({super.key, required this.answer, required this.onTap});

  @override
  State<QuizButton> createState() => _QuizButtonState();
}

bool isSelected = false;

class _QuizButtonState extends State<QuizButton> {
  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 5,
        child: GestureDetector(
          onTap: () {
            setState(
              () {
                isSelected = !isSelected;
                widget.onTap;
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: isSelected ? UiColors().teal : Colors.white,),
            width: widthDevice,
            
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
