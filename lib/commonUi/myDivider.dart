import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
          height: 0.2,
          width: widthDevice,
          color: Color.fromARGB(255, 128, 126, 126),
        );
  }
}