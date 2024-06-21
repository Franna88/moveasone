import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/models/watchMemberModel.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class WatchedMembersListView extends StatelessWidget {
  const WatchedMembersListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice,
      height: heightDevice * 0.90,
      child: ListView.builder(
          itemCount: watchedMembers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 25,
                          backgroundImage:
                              AssetImage(watchedMembers[index].memberImage),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          watchedMembers[index].memberName,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        Spacer(),
                        WatchButton()
                      ],
                    ),
                  ),
                  MyDivider()
                ],
              ),
            );
          }),
    );
  }
}
