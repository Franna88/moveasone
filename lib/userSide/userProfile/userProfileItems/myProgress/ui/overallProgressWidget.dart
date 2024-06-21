import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/CircularPercentageProgressBar.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/mainContentContainer.dart';

class OverallProgressWidget extends StatelessWidget {
  const OverallProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContentContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularPercentageProgressBar(percentage: 74),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Great!',
                      style: TextStyle(
                        fontFamily: 'BeVietnam',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Today\'s plan is more than\n half done keep her steady!',
                      style: TextStyle(
                        fontFamily: 'BeVietnam',
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}