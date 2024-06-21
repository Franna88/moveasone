import 'package:flutter/material.dart';

class CreatorContainer extends StatelessWidget {
  final List<Widget> children;
  const CreatorContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.75,
      width: widthDevice,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}