import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/bookings/myScedule/ui/myDateTimePicker.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/userSide/appointment/ui/bookingRequestCon.dart';
import 'package:move_as_one/userSide/appointment/ui/userInfoContainer.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class AppointmentMain extends StatelessWidget {
  const AppointmentMain({super.key});

  //TO DO

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'APPOINTMENT'),
        const SizedBox(
          height: 20,
        ),
        UserInfoContainer(
            userPic: 'images/comment1.jpg',
            ratingContainerColor: UiColors().teal,
            rating: '4.7',
            userName: 'Lena Rosser',
            userRank: 'Beginner',
            exercisesCompleted: '27 Exercises Completed'),
        const SizedBox(
          height: 20,
        ),
        BookingRequestCon(userName: 'Rachelle Holm'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyDateTimePicker(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CommonButtons(
              buttonText: 'Request Booking',
              onTap: () {
                //ADD LOGIC HERE
              },
              buttonColor: UiColors().teal),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
