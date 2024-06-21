import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/models/selectedDayModel.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/myProgress/ui/selectDayContainer.dart';

class SelectedDayListView extends StatefulWidget {
  const SelectedDayListView({super.key});

  @override
  State<SelectedDayListView> createState() => _SelectedDayListViewState();
}

class _SelectedDayListViewState extends State<SelectedDayListView> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedDay.length,
          itemBuilder: (context, index) {
            return SelectDayContainer(
                weekDay: selectedDay[index].weekDay,
                currentDate: selectedDay[index].currentDate);
          }),
    );
  }
}
