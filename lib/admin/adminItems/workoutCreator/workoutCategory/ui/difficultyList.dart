import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/models/dificultyModel/difficultyModel.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/selectWeekdayScreen.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/mySwitchButton.dart';

class DifficultyList extends StatelessWidget {
  const DifficultyList({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.80,
      child: ListView.builder(
          itemCount: difficultyItems.length,
          itemBuilder: (context, index) {
            return Column(
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
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectWeekdayScreen()),
                          );
                        },
                        child: Container(
                          height: heightDevice * 0.11,
                          width: widthDevice * 0.24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(
                                  difficultyItems[index].difficultyImage),
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
                            difficultyItems[index].difficultyLevel,
                            style: TextStyle(
                               fontFamily: 'Inter',
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            difficultyItems[index].memberCount,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      MySwitchButton()
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
