import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/ui/pickTimeButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:table_calendar/table_calendar.dart';

class MyDateTimePicker extends StatefulWidget {
  const MyDateTimePicker({super.key});

  @override
  State<MyDateTimePicker> createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
  DateTime _focusDay = DateTime.now();
  DateTime? _selectedDay;

  _onDaySelected(selectedDay, focusDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusDay = focusDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Container(
        width: widthDevice,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 240, 230, 250),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                rowHeight: 45,
                daysOfWeekHeight: 20,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: ShapeDecoration(
                      shape: CircleBorder(), color: UiColors().teal),
                  todayTextStyle: TextStyle(color: Colors.black),
                  todayDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 241, 235, 243),
                    border: Border.all(color: UiColors().teal),
                  ),
                ),
                focusedDay: _focusDay,
                firstDay: DateTime.utc(2024, 06, 19),
                lastDay: DateTime.utc(2044, 06, 19),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  children: [
                    PickTimeButtons(time: '09:00 AM'),
                    PickTimeButtons(time: '09:30 AM'),
                    PickTimeButtons(time: '10:00 AM'),
                    PickTimeButtons(time: '10:30 AM'),
                    PickTimeButtons(time: '11:30 AM'),
                    PickTimeButtons(time: '12:00 AM'),
                    PickTimeButtons(time: '12:30 PM'),
                    PickTimeButtons(time: '13:00 PM'),
                    PickTimeButtons(time: '13:30 PM'),
                    PickTimeButtons(time: '14:00 PM'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
