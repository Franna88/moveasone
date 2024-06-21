import 'package:flutter/material.dart';

class GreyContainer extends StatelessWidget {
  Function() onTap;
  final Widget child;
  GreyContainer({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: const Color.fromARGB(0, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
          elevation: 6,
          child: Container(
            width: widthDevice * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
