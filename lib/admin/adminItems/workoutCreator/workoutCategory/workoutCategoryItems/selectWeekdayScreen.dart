import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/workoutCreator.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/weekdaySelectListView.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class SelectWeekdayScreen extends StatefulWidget {
  final String documentId;
  final String category;
  final List<String> selectedCategories;
  final String difficulty;

  const SelectWeekdayScreen({
    required this.documentId,
    required this.category,
    required this.selectedCategories,
    required this.difficulty,
    super.key,
  });

  @override
  State<SelectWeekdayScreen> createState() => _SelectWeekdayScreenState();
}

class _SelectWeekdayScreenState extends State<SelectWeekdayScreen> {
  List<String> selectedWeekdays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(header: widget.category),
            Expanded(
              child: WeekdaySelectListView(
                onWeekdaySelected: (weekday) {
                  setState(() {
                    if (selectedWeekdays.contains(weekday)) {
                      selectedWeekdays.remove(weekday);
                    } else {
                      selectedWeekdays.add(weekday);
                    }
                  });
                },
              ),
            ),
            MyDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: CommonButtons(
                buttonText: 'Save',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutCreator(
                        documentId: widget.documentId,
                        category: widget.category,
                        selectedCategories: widget.selectedCategories,
                        difficulty: widget.difficulty,
                        selectedWeekdays: selectedWeekdays,
                      ),
                    ),
                  );
                },
                buttonColor: AdminColors().lightBrown,
              ),
            )
          ],
        ),
      ),
    );
  }
}
