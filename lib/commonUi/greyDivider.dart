import 'package:flutter/material.dart';

class GreyDivider extends StatelessWidget {
  const GreyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
              height: 0.2,
              width: widthDevice,
              color: Color.fromARGB(255, 128, 126, 126),
            ),
    );
  }
}