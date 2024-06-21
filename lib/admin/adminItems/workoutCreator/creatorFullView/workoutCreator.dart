import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/myCreatorHeaders.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/creatorTextFieldBig.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/creatorTextFieldSmall.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/myTagButtons.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/questionConHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/ui/creatorContainer.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/ui/myTimerSlider.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/warmUpCreator.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

List bodyAreaList = [
  'Full body',
  'Upper body',
  'Cardio & Core',
  'Legs',
];

List difficultyList = [
  'Basic',
  'Intermediate',
  'Tough',
];

List equipmentList = [
  'No Equipment',
  'Dumbbells',
  'Kettlebell',
  'Resistance Bands',
  'Skipping Rope',
  'Step',
  'Mat',
  'Battle Rope',
  'Plyo Box',
  'Fixed Straight Bar',
  'Weighted Barbell',
  'Slam Ball',
  'Airbike',
  'Indoor Rower',
];

List restingPeriodList = [
  '1 min',
  '1 min 15 Sec',
  '1 min 30 Sec',
  '2 min',
  '2 min 15 Sec',
];

class WorkoutCreator extends StatelessWidget {
  const WorkoutCreator({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: heightDevice,
        width: widthDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/placeHolder1.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: widthDevice * 0.80,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'WORKOUT CREATOR',
                          style: TextStyle(
                            fontFamily: 'Inter',
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyTimeSlider(),
              Spacer(),
              CreatorContainer(
                children: [
                  QuestionConHeader(header: 'WORKOUT CREATOR'),
                  Container(
                    height: heightDevice * 0.65,
                    width: widthDevice,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CreatorTextFieldSmall(
                              hintText: 'Workout Name',
                              onChanged: () {
                                //ADD LOGIC HERE
                              },
                            ),
                            CreatorTextFieldBig(
                                onChanged: () {
                                  //ADD LOGIC HERE
                                },
                                hintText: 'Workout Description'),
                            MyCreatorHeaders(text: 'Body Area'),
                            Wrap(
                              children: [
                                for (var i = 0; i < bodyAreaList.length; i++)
                                  MyTagButtons(
                                    tagText: bodyAreaList[i],
                                  ),
                              ],
                            ),
                            MyCreatorHeaders(text: 'Equipment'),
                            Wrap(
                              children: [
                                for (var i = 0; i < equipmentList.length; i++)
                                  MyTagButtons(
                                    tagText: equipmentList[i],
                                  ),
                              ],
                            ),
                            MyCreatorHeaders(text: 'Resting Period'),
                            Wrap(
                              children: [
                                for (var i = 0;
                                    i < restingPeriodList.length;
                                    i++)
                                  MyTagButtons(
                                    tagText: restingPeriodList[i],
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            MyCreatorHeaders(text: 'Warmup Photo'),
                            CommonButtons(
                                buttonText: 'Select Image',
                                onTap: () {
                                  //ADD LOGIC
                                },
                                buttonColor: AdminColors().lightTeal),
                            const SizedBox(
                              height: 10,
                            ),
                            MyCreatorHeaders(text: 'Workout Photo'),
                            CommonButtons(
                                buttonText: 'Select Image',
                                onTap: () {
                                  //ADD LOGIC
                                },
                                buttonColor: AdminColors().lightTeal),
                            const SizedBox(
                              height: 10,
                            ),
                            MyCreatorHeaders(text: 'Cooldown Photo'),
                            CommonButtons(
                                buttonText: 'Select Image',
                                onTap: () {
                                  //ADD LOGIC
                                },
                                buttonColor: AdminColors().lightTeal),
                            SizedBox(
                              height: heightDevice * 0.08,
                            ),
                            MyDivider(),
                            const SizedBox(
                              height: 15,
                            ),
                            CommonButtons(
                                buttonText: 'Create Warmup',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WarmUpCreator()),
                                  );
                                  //ADD ROUTE
                                },
                                buttonColor: AdminColors().lightBrown),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
