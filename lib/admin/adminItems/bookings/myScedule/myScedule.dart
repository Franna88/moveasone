import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/bookings/commonUi/bookingUserItem.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/ui/myDateTimePicker.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class MyScedule extends StatelessWidget {
  const MyScedule({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'APPOINTMENT'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: MyDateTimePicker(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(4, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              children: [
                
                BookingUserItem(
                    userPic: 'images/comment1.jpg',
                    userName: 'Anika Workman',
                    bookingDate: '10 April 2024 (12:00-16:00)',
                    timeStamp: 'Yesterday'),
                BookingUserItem(
                    userPic: 'images/comment2.jpg',
                    userName: 'Lift Core Focus',
                    bookingDate: '13 April 2024 (12:00-13:00)',
                    timeStamp: '27 min ago'),
                BookingUserItem(
                    userPic: 'images/comment3.jpg',
                    userName: 'Alan Thorn',
                    bookingDate: '23 April 2024 (10:00-13:00)',
                    timeStamp: '23 Agu 2023'),
                BookingUserItem(
                    userPic: 'images/comment1.jpg',
                    userName: 'Anika Workman',
                    bookingDate: '25 April 2024 (09:00-11:00)',
                    timeStamp: 'Y12 Jun 2023'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
