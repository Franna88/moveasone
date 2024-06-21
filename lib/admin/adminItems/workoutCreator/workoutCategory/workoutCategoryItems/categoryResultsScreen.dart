import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/categoryResultsListView.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class CategoryResultsScreen extends StatelessWidget {
  const CategoryResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(header: 'AT HOME-BEGINNER-MONDAY'),
            CategoryResultsListView(),
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
