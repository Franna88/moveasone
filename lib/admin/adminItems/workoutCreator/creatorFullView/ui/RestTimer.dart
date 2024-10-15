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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTimeSelected(_minutes, _seconds);
          },
          child: Text('Set Time'),
        ),
      ],
    );
  }
}
