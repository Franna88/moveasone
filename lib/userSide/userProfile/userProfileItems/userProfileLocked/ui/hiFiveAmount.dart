import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class HiFiveAmount extends StatelessWidget {
  final String hiFivesAmount;
  const HiFiveAmount({super.key, required this.hiFivesAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HIGH FIVE\'S',
                  style: TextStyle(
                    fontFamily: 'Inter',
                      fontSize: 11,
                      color: UiColors().textgrey,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 2,),
                Text(
                  hiFivesAmount,
                  style: TextStyle(
                    
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            );
  }
}