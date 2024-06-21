import 'package:flutter/material.dart';

class MainContentContainer extends StatelessWidget {
  final Widget child;
  const MainContentContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      
      width: widthDevice * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 187, 187, 187),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: child,
      ),
    );
  }
}
