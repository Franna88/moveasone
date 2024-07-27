import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class SaveButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onTap;
  SaveButton({super.key, required this.buttonText, required this.onTap});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widthDevice * 0.90,
        decoration: BoxDecoration(
          color: UiColors().teal,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              widget.buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
