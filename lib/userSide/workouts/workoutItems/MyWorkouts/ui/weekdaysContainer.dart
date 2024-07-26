import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/defaultWorkoutDetails/defaultWorkoutDetails.dart';

class WeekdaysContainer extends StatefulWidget {
  final Function(int) changePageIndex;
  final List<Map<String, dynamic>> workoutDocuments;

  WeekdaysContainer({
    super.key,
    required this.changePageIndex,
    required this.workoutDocuments,
  });

  @override
  State<WeekdaysContainer> createState() => _WeekdaysContainerState();
}

class _WeekdaysContainerState extends State<WeekdaysContainer> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Container(
      height: heightDevice * 0.75,
      child: ListView.builder(
        itemCount: widget.workoutDocuments.length,
        itemBuilder: (context, index) {
          var workout = widget.workoutDocuments[index];
          var docId = workout['docId'];
          var warmupPhoto = workout['warmupPhoto'];
          var selectedWeekdays = workout['selectedWeekdays'];
          var bodyArea = workout['bodyArea'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              child: GestureDetector(
                onTap: () {
                  widget.changePageIndex(1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DefaultWorkoutDetails(
                        docId: docId,
                        userType: 'user',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: heightDevice * 0.22,
                  width: widthDevice * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: warmupPhoto.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(warmupPhoto),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$selectedWeekdays \n',
                              style: TextStyle(
                                fontFamily: 'BeVietnam',
                                fontSize: 23,
                                color: UiColors().brown,
                              ),
                            ),
                            TextSpan(
                              text: bodyArea,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: const Color.fromARGB(170, 95, 58, 1),
                              ),
                            ),
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
