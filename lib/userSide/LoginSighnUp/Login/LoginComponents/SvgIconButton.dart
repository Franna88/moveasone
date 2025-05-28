import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  // New color palette
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
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: SvgPicture.asset(
          iconPath,
          width: 36,
          height: 36,
        ),
      ),
    );
  }
}
