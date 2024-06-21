import 'package:flutter/material.dart';

class ArrowRightIcon extends StatelessWidget {
  const ArrowRightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
                  Icons.keyboard_arrow_right,
                  color: Color.fromARGB(255, 128, 126, 126),
                  size: 30,
                );
  }
}