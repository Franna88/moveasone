import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/models/categoryModel/categoryModel.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/workoutCategory/workoutCategoryItems/selectDifficultyScreen.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/CategoryButton.dart';

class CategorysWidget extends StatefulWidget {
  final String documentId;
  final Function(List<String>)
      onCategoriesChanged; // Callback to get selected categories

  const CategorysWidget({
    required this.documentId,
    required this.onCategoriesChanged,
    super.key,
  });

  @override
  State<CategorysWidget> createState() => _CategorysWidgetState();
}

class _CategorysWidgetState extends State<CategorysWidget> {
  List<String> selectedCategories = [];

  void addRemoveWorkoutCategory(String value) {
    setState(() {
      if (selectedCategories.contains(value)) {
        selectedCategories.remove(value);
      } else {
        selectedCategories.add(value);
      }
      widget.onCategoriesChanged(
          selectedCategories); // Notify parent about changes
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
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
                            builder: (context) => SelectDifficultyScreen(
                              documentId: widget.documentId,
                              category: workoutCategories[index].categoryName,
                              selectedCategories: selectedCategories,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: heightDevice * 0.11,
                        width: widthDevice * 0.24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                                workoutCategories[index].workoutImage),
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
                          workoutCategories[index].categoryName,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: heightDevice * 0.02),
                        CategoryButton(
                          status: workoutCategories[index].selected,
                          onToggle: (val) {
                            setState(() {
                              workoutCategories[index].selected = val;
                            });
                            addRemoveWorkoutCategory(
                                workoutCategories[index].categoryName);
                          },
                        ),
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
        },
        childCount: workoutCategories.length,
      ),
    );
  }
}
