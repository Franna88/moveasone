import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/workoutCreator.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/categorysWidget.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';


class WorkoutCategoryMain extends StatelessWidget {
  const WorkoutCategoryMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(header: 'WORKOUT CATEGORY'),
            CategorysWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
              child: CommonButtons(
                  buttonText: 'Create New Workout', onTap: (){
                    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WorkoutCreator()),
  );
                    //ADD LOGIC HERE
                  }, buttonColor: AdminColors().lightBrown),
            )
          ],
        ),
      ),
    );
  }
}
