import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class SvgIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  // Color palette matching the app
  static const primaryColor = Color(0xFF6699CC); // Cornflower Blue
  static const secondaryColor = Color(0xFF94D8E0); // Pale Turquoise

  const SvgIconButton({
    required this.iconPath,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: SvgPicture.asset(
              iconPath,
              width: 36,
              height: 36,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
