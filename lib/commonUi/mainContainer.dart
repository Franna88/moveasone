import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget {
  final List<Widget> children;
  const MainContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: heightDevice,
        width: widthDevice,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
