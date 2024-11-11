import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/columnHeader.dart';
import 'package:move_as_one/admin/adminItems/bookings/bookingsRequested/bookingsRequested.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/WatchedMembers.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/AllMemberList.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';

class MembersColumn extends StatefulWidget {
  const MembersColumn({super.key});

  @override
  State<MembersColumn> createState() => _MembersColumnState();
}

class _MembersColumnState extends State<MembersColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnHeader(header: 'Members'),
          CommonButtons(
              buttonText: '3 Days Inactive',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WatchedMembers()),
                );
                //ADD LOGIC HERE
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: '6 Days Inactive',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WatchedMembers()),
                );
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: 'Low Motivated',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WatchedMembers()),
                );
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: 'Watched',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WatchedMembers()),
                );
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: 'Bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookingsRequested()),
                );
                //ADD LOGIC HERE
              },
              buttonColor: AdminColors().lightTeal),
          const SizedBox(
            height: 10,
          ),
          CommonButtons(
              buttonText: 'All Members',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllMemberList()),
                );
                //ADD LOGIC HERE
              },
              buttonColor: AdminColors().lightTeal),
        ],
      ),
    );
  }
}
