import 'package:flutter/material.dart';

class RestTimer extends StatefulWidget {
  final Function(int minutes, int seconds) onTimeSelected;

  RestTimer({required this.onTimeSelected});

  @override
  _RestTimerState createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  int _minutes = 0;
  int _seconds = 0;

  void _updateTime() {
    widget.onTimeSelected(_minutes, _seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rest Time",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: _minutes,
                items: List.generate(60, (index) => index)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _minutes = value!;
                    _updateTime(); // Save the time when minutes change
                  });
                },
              ),
              Text(':'),
              DropdownButton<int>(
                value: _seconds,
                items: List.generate(60, (index) => index)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _seconds = value!;
                    _updateTime(); // Save the time when seconds change
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
