import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/models/categoryModel/categoryModel.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/categoryResultsListView.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/selectDifficultyScreen.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/mySwitchButton.dart';

class CategorysWidget extends StatelessWidget {
  
  
  const CategorysWidget(
      {super.key,});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.80,
      child: ListView.builder(
        itemCount: workoutCategories.length,
        itemBuilder: (context, index) {
        return
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 20, left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SelectDifficultyScreen()),
  );
                    },
                    child: Container(
                      height: heightDevice * 0.11,
                      width: widthDevice * 0.24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(workoutCategories[index].workoutImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workoutCategories[index].categoryName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: heightDevice * 0.02,
                      ),
                      MySwitchButton()
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: MyDivider(),
            ),
          ],
        );
      }),
    );
  }
}
