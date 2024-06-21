import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/bookings/commonUi/bookingUserItem.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/myScedule.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class BookingsRequested extends StatelessWidget {
  const BookingsRequested({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(
          header: 'BOOKINGS REQUESTED',
        ),
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
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25 , vertical: 50),
          child: CommonButtons(
              buttonText: 'My Scedule', onTap: (){
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyScedule()),
  );
                //ADD ROUTE
              }, buttonColor: AdminColors().lightTeal),
        )
      ],
    );
  }
}
