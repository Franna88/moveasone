import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/weekdaySelectListView.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class SelectWeekdayScreen extends StatelessWidget {
  const SelectWeekdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(header: 'AT HOME-BEGINNER'),
            WeekdaySelectListView(),
            MyDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
              child: CommonButtons(
                  buttonText: 'Save', onTap: (){
                      //ADD LOGIC HERE
                  }, buttonColor: AdminColors().lightBrown),
            )
          ],
        ),
      ),
    );
  }
}
