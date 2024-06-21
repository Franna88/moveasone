import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/ui/weekdayModel/weekdayListModel.dart';

class WeekdaysContainer extends StatelessWidget {
  Function(int) changePageIndex;
  WeekdaysContainer({super.key, required this.changePageIndex});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.75,
      child: ListView.builder(
        itemCount: weekdayExercise.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              child: GestureDetector(
                onTap: () {
                  changePageIndex(1);
                },
                child: Container(
                  height: heightDevice * 0.22,
                  width: widthDevice * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage(weekdayExercise[index].assetName),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${weekdayExercise[index].weekday} \n',
                              style: TextStyle(
                                fontFamily: 'BeVietnam',
                                fontSize: 23,
                                color: UiColors().brown,
                              ),
                            ),
                            TextSpan(
                              text: weekdayExercise[index].exercise,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: const Color.fromARGB(170, 95, 58, 1),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
