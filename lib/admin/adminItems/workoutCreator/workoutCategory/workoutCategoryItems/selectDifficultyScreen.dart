import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/ui/difficultyList.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/selectWeekdayScreen.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class SelectDifficultyScreen extends StatefulWidget {
  final String documentId;
  final String category;
  final List<String> selectedCategories;

  const SelectDifficultyScreen(
      {required this.documentId,
      required this.category,
      required this.selectedCategories,
      super.key});

  @override
  State<SelectDifficultyScreen> createState() => _SelectDifficultyScreenState();
}

class _SelectDifficultyScreenState extends State<SelectDifficultyScreen> {
  String selectedDifficulty = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HeaderWidget(header: widget.category),
            ),
            DifficultyList(
              onDifficultySelected: (difficulty) {
                setState(() {
                  selectedDifficulty = difficulty;
                });
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: CommonButtons(
                  buttonText: 'Save',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectWeekdayScreen(
                          documentId: widget.documentId,
                          category: widget.category,
                          selectedCategories: widget.selectedCategories,
                          difficulty: selectedDifficulty,
                        ),
                      ),
                    );
                  },
                  buttonColor: AdminColors().lightBrown,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: MyDivider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
