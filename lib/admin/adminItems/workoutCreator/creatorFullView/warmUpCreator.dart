import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/myCreatorHeaders.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/creatorTextFieldBig.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/creatorTextFieldSmall.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/myTagButtons.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/commonUi/questionConHeader.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/ui/creatorContainer.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/ui/myTimerSlider.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorVideoRecord.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/creatorVoiceRecord.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

List topicsList = [
  'Peace',
  'Radiance',
  'Strength',
  'Love',
  'Joy',
  'Creative',
];
List warmupDifficultyList = [
  'Basic',
  'Intermediate',
  'Tough',
];
List warmUpEquipmentList = [
  'No equipment',
  'Dumbells',
  'Kettlebell',
  'Resistence Bands',
];

class WarmUpCreator extends StatelessWidget {
  const WarmUpCreator({super.key});

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
                          'WARMUP CREATOR',
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
                  QuestionConHeader(header: 'WARMUP CREATOR'),
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
                              hintText: 'Warmup Title',
                              onChanged: () {
                                //ADD LOGIC HERE
                              },
                            ),
                            CreatorTextFieldBig(
                                onChanged: () {
                                  //ADD LOGIC HERE
                                },
                                hintText: 'Content'),
                            MyCreatorHeaders(text: 'Topics'),
                            Wrap(
                              children: [
                                for (var i = 0; i < topicsList.length; i++)
                                  MyTagButtons(
                                    tagText: topicsList[i],
                                  ),
                              ],
                            ),
                            MyCreatorHeaders(text: 'Difficulty'),
                            Wrap(
                              children: [
                                for (var i = 0; i < warmupDifficultyList.length; i++)
                                  MyTagButtons(
                                    tagText: warmupDifficultyList[i],
                                  ),
                              ],
                            ),
                            MyCreatorHeaders(text: 'Equipment'),
                            Wrap(
                              children: [
                                for (var i = 0;
                                    i < warmUpEquipmentList.length;
                                    i++)
                                  MyTagButtons(
                                    tagText: warmUpEquipmentList[i],
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                           
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
    MaterialPageRoute(builder: (context) => const CreatorVoiceRecord()),
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
