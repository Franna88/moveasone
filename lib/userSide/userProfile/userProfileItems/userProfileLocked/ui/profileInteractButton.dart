import 'package:flutter/material.dart';

class ProfileInteractButton extends StatelessWidget {
  Widget buttonChild;
  Function() onTap;
  ProfileInteractButton(
      {super.key, required this.buttonChild, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
  }
}
