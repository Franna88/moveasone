import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/models/weekDaySelect/weekDaySelectModel.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/NewSwitchBUtton.dart';

class WeekdaySelectListView extends StatefulWidget {
  final ValueChanged<String> onWeekdaySelected;

  const WeekdaySelectListView({super.key, required this.onWeekdaySelected});

  @override
  State<WeekdaySelectListView> createState() => _WeekdaySelectListViewState();
}

class _WeekdaySelectListViewState extends State<WeekdaySelectListView> {
  String selectedWeekday = '';

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, bottom: 20, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWeekday = weekDaySelection[index].weekDay;
                              for (var item in weekDaySelection) {
                                item.selected = item.weekDay == selectedWeekday;
                              }
                            });
                            widget.onWeekdaySelected(selectedWeekday);
                          },
                          child: Container(
                            height: heightDevice * 0.11,
                            width: widthDevice * 0.24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image:
                                    AssetImage(weekDaySelection[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weekDaySelection[index].weekDay,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            /*   Text(
                             weekDaySelection[index].exerciseType,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),*/
                          ],
                        ),
                        const Spacer(),
                        Newswitchbutton(
                          initialValue: weekDaySelection[index].selected,
                          onToggle: (val) {
                            setState(() {
                              weekDaySelection[index].selected = val;
                              if (val) {
                                selectedWeekday =
                                    weekDaySelection[index].weekDay;
                                for (var item in weekDaySelection) {
                                  if (item.weekDay != selectedWeekday) {
                                    item.selected = false;
                                  }
                                }
                                widget.onWeekdaySelected(selectedWeekday);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: MyDivider(),
                  ),
                ],
              );
            },
            childCount: weekDaySelection.length,
          ),
        ),
      ],
    );
  }

  Future<void> saveSelectedWeekdayToFirestore(String weekday) async {
    await FirebaseFirestore.instance.collection('selectedWeekdays').add({
      'selectedWeekday': weekday,
      'timestamp': Timestamp.now(),
    });
  }
}
