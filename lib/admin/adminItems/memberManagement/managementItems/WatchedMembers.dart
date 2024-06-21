import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchedMembersListView.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class WatchedMembers extends StatelessWidget {
  const WatchedMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: 'WATCHED MEMBERS'),
        WatchedMembersListView()
      ],
    );
  }
}
