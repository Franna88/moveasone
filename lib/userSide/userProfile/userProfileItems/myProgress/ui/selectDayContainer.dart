import 'package:flutter/material.dart';

class SelectDayContainer extends StatefulWidget {
  final String weekDay;
  final String currentDate;
  const SelectDayContainer({super.key, required this.weekDay, required this.currentDate});

  @override
  State<SelectDayContainer> createState() => _SelectDayContainerState();
}

class _SelectDayContainerState extends State<SelectDayContainer> {
   bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.weekDay,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.currentDate,
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}