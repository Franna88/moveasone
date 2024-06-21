import 'package:flutter/material.dart';

import 'package:move_as_one/myutility.dart';

class ProgressBar extends StatelessWidget {
  final int currentPage;
  final Duration animationDuration;
  final double initialFill;

  const ProgressBar({
    Key? key,
    required this.currentPage,
    this.animationDuration = const Duration(milliseconds: 500),
    this.initialFill = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MyUtility(context).width / 1.2,
      height: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xFFD6D6D6),
            ),
            AnimatedContainer(
              duration: animationDuration,
              width: MyUtility(context).width / 1.2 * (currentPage + 1) / 6.0,
              height: double.infinity,
              color: Color(0xFF006261),
            ),
          ],
        ),
      ),
    );
  }
}
