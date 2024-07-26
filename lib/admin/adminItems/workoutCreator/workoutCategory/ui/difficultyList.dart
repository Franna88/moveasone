import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/models/dificultyModel/difficultyModel.dart';
import 'package:move_as_one/commonUi/NewSwitchBUtton.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/mySwitchButton.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/editProfile/ui/NewSwitchbutton.dart';

class DifficultyList extends StatefulWidget {
  final ValueChanged<String> onDifficultySelected;

  const DifficultyList({super.key, required this.onDifficultySelected});

  @override
  State<DifficultyList> createState() => _DifficultyListState();
}

class _DifficultyListState extends State<DifficultyList> {
  String selectedDifficulty = '';

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
                        setState(() {
                          selectedDifficulty =
                              difficultyItems[index].difficultyLevel;
                          for (var item in difficultyItems) {
                            item.selected =
                                item.difficultyLevel == selectedDifficulty;
                          }
                        });
                        widget.onDifficultySelected(selectedDifficulty);
                      },
                      child: Container(
                        height: heightDevice * 0.11,
                        width: widthDevice * 0.24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                              difficultyItems[index].difficultyImage,
                            ),
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
                          difficultyItems[index].difficultyLevel,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        /*  Text(
                          difficultyItems[index].memberCount,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                          ),
                        ),*/
                      ],
                    ),
                    const SizedBox(width: 25),
                    Newswitchbutton(
                      initialValue: difficultyItems[index].selected,
                      onToggle: (val) {
                        setState(() {
                          difficultyItems[index].selected = val;
                          if (val) {
                            selectedDifficulty =
                                difficultyItems[index].difficultyLevel;
                            for (var item in difficultyItems) {
                              if (item.difficultyLevel != selectedDifficulty) {
                                item.selected = false;
                              }
                            }
                            widget.onDifficultySelected(selectedDifficulty);
                          }
                        });
                      },
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
        childCount: difficultyItems.length,
      ),
    );
  }
}
