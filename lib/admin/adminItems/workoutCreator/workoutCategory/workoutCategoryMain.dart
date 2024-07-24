import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/categorysWidget.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'workoutCategoryItems/selectDifficultyScreen.dart';

class WorkoutCategoryMain extends StatefulWidget {
  const WorkoutCategoryMain({super.key});

  @override
  _WorkoutCategoryMainState createState() => _WorkoutCategoryMainState();
}

class _WorkoutCategoryMainState extends State<WorkoutCategoryMain> {
  List<String> selectedCategories = [];

  void _handleCategoriesChanged(List<String> categories) {
    setState(() {
      selectedCategories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String documentId =
        FirebaseFirestore.instance.collection('createWorkout').doc().id;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HeaderWidget(header: 'WORKOUT CATEGORY'),
            ),
            CategorysWidget(
              documentId: documentId,
              onCategoriesChanged: _handleCategoriesChanged,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: CommonButtons(
                  buttonText: 'Create New Workout',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectDifficultyScreen(
                          documentId: documentId,
                          category: '', // Pass appropriate category if needed
                          selectedCategories: selectedCategories,
                        ),
                      ),
                    );
                  },
                  buttonColor: AdminColors().lightBrown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
