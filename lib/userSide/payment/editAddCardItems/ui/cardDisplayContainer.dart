import 'package:flutter/material.dart';

class CardDisplayContainer extends StatelessWidget {
  const CardDisplayContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 350,
        maxHeight: 200
      ),
      child: Container(
        height: heightDevice * 0.20,
        width: widthDevice * 90,
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text('Placeholder')),
      ),
    );
  }
}
