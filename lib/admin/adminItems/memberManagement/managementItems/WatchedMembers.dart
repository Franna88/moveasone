import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchedMembersListView.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

enum MemberFilterType { threeDay, sixDay, lowMotivation, watched, all }

class WatchedMembers extends StatelessWidget {
  final MemberFilterType filterType;

  const WatchedMembers({super.key, this.filterType = MemberFilterType.sixDay});

  String _getHeaderText() {
    switch (filterType) {
      case MemberFilterType.threeDay:
        return '3 DAYS INACTIVE MEMBERS';
      case MemberFilterType.sixDay:
        return '6 DAYS INACTIVE MEMBERS';
      case MemberFilterType.lowMotivation:
        return 'LOW MOTIVATED MEMBERS';
      case MemberFilterType.watched:
        return 'WATCHED MEMBERS';
      case MemberFilterType.all:
        return 'ALL MEMBERS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget(header: _getHeaderText()),
        WatchedMembersListView(filterType: filterType)
      ],
    );
  }
}
