import 'package:flutter/material.dart';

class ProfileInteractButton extends StatelessWidget {
  Widget buttonChild;
  Function() onTap;
  ProfileInteractButton(
      {super.key, required this.buttonChild, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: widthDevice * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: buttonChild,
            ),
          ),
        ),
      ),
    );
  }
}
