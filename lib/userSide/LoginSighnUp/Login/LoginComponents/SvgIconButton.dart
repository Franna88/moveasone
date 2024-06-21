import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SvgIconButton({
    required this.iconPath,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        iconPath,
        width: 60,
        height: 60,
      ),
    );
  }
}
