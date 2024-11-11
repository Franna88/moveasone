import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/allMembersListView.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class AllMembers extends StatelessWidget {
  const AllMembers({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        HeaderWidget(header: 'ALL MEMBERS'),
        const SizedBox(height: 20,),
        AllMembersListView()
      ],
    );
  }
}
