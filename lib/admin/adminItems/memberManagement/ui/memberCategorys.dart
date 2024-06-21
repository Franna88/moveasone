import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class MemberCategorys extends StatelessWidget {
  final String categoryText;
  Function() onTap;
  MemberCategorys({super.key, required this.categoryText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric( vertical: 20),
              child: Text(
                categoryText,
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            MyDivider()
          ],
        ),
      ),
    );
  }
}
