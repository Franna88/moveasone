import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/CircularPercentageProgressBar.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/ui/activitiesDropDown.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsColors.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsProgressBar.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/goalsWidget.dart';
import 'package:move_as_one/userSide/userProfile/commonUi/mainContentContainer.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/ui/overallProgressWidget.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/ui/selectedDayListView.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/ui/userGoalContainers.dart';

class MyProgressMain extends StatelessWidget {
  const MyProgressMain({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        HeaderWidget(header: 'MY PROGRESS'),
        Container(
          height: heightDevice * 0.88,
          width: widthDevice,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SelectedDayListView(),
                const SizedBox(
                  height: 20,
                ),
                OverallProgressWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserGoalContainers(
                        color: Color.fromARGB(255, 177, 216, 211),
                        icon: Icons.do_not_step,
                        amount: '24',
                        infoType: 'Exercises'),
                    UserGoalContainers(
                        color: Color.fromARGB(255, 238, 215, 199),
                        icon: Icons.electric_bolt_sharp,
                        amount: '1209',
                        infoType: 'Calories'),
                    UserGoalContainers(
                        color: Color(0xFFE2EAFF),
                        icon: Icons.alarm,
                        amount: '64',
                        infoType: 'Minutes'),
                  ],
                ),
                ActivitiesDropDown(),
                MainContentContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 90),
                    child: Text(
                      textAlign: TextAlign.center,
                      'CHART PLACEHOLDER',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text(
                      textAlign: TextAlign.left,
                      'Goals',
                      style: TextStyle(fontSize: 20,fontFamily: 'BeVietnam',),
                    ),
                  ),
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: GoalsColors().green,
                    iconColor: Colors.white,
                    iconType: Icons.check,
                    borderColor: GoalsColors().green,
                    barColor: GoalsColors().green,
                    percentage: '100%',
                    goal: 'Weight Goal',
                    progressValue: 100,
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: GoalsColors().yellow,
                    iconColor: Colors.black,
                    iconType: Icons.priority_high,
                    borderColor: GoalsColors().yellow,
                    barColor: GoalsColors().yellow,
                    percentage: '50%',
                    goal: 'Arms Goal',
                    progressValue: 0.50,
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: Colors.white,
                    iconColor: GoalsColors().blue,
                    iconType: Icons.circle,
                    borderColor: GoalsColors().blue,
                    barColor: GoalsColors().blue,
                    percentage: '30%',
                    goal: 'Legs Goal',
                    progressValue: 0.30,
                    iconSize: 11,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MainContentContainer(
                  child: GoalsWidget(
                    conColor: GoalsColors().red,
                    iconColor: Colors.white,
                    iconType: Icons.close,
                    borderColor: GoalsColors().red,
                    barColor: GoalsColors().red,
                    percentage: '10%',
                    goal: 'Waist Goal',
                    progressValue: 0.10,
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}
