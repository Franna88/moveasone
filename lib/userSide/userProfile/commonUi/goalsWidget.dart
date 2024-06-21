import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsIconWidget.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsProgressBar.dart';

class GoalsWidget extends StatelessWidget {
  final Color conColor;
  final Color iconColor;
  final IconData iconType;
  final Color borderColor;
  final Color barColor;
  final String percentage;
  final String goal;
  final double progressValue;
  final double iconSize;
  const GoalsWidget(
      {super.key,
      required this.conColor,
      required this.iconColor,
      required this.iconType,
      required this.borderColor,
      required this.barColor,
      required this.percentage,
      required this.goal, required this.progressValue, required this.iconSize, });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GoalsIconWidget(
              conColor: conColor,
              iconColor: iconColor,
              iconType: iconType,
              borderColor: borderColor, iconSize: iconSize,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      percentage,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      goal,
                      style: TextStyle(
                        fontFamily: 'BeVietnam',
                        fontSize: 11,
                        color: UiColors().textgrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                GoalsProgressBar(barColor: barColor, barValue: progressValue, ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
