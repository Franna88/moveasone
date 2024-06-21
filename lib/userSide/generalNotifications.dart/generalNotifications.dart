import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/generalNotifications.dart/UI/notificationItem.dart';

class GeneralNotifications extends StatelessWidget {
  const GeneralNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'NOTIFICATIONS'),
        NotitficationItem(
            userPic: 'images/Avatar1.jpg',
            userName: 'Anika Workman',
            notification: 'Review your trainer',
            timeStamp: 'Yesterday'),
      ],
    );
  }
}
