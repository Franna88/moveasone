import 'package:flutter/material.dart';

class ActivitiesDropDown extends StatefulWidget {
  @override
  _ActivitiesDropDownState createState() => _ActivitiesDropDownState();
}

class _ActivitiesDropDownState extends State<ActivitiesDropDown> {
  String selectedDuration = 'Daily'; // Default selected duration

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Activities',
            style: TextStyle(fontSize: 20, fontFamily: 'BeVietnam'),
          ),
          DropdownButton<String>(
            dropdownColor: Colors
                .grey[100], // Set dropdown background color to a lighter shade
            elevation: 1,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 20,
            ),
            value: selectedDuration,
            onChanged: (String? newValue) {
              setState(() {
                selectedDuration = newValue!;
              });
            },
            items: <String>['Daily', 'Weekly', 'Monthly']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'BeVietnam',
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
