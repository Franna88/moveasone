import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  final String buttonText;
  Function() onTap;
  BlackButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widthDevice * 0.90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 36, 35, 35),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              buttonText,
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
