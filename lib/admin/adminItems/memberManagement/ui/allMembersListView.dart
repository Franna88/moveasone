import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/memberProfile.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/models/allMembersModel.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/profileAbout.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/fullMemberWidget.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/userSide/userProfile/UserProfile.dart';

class AllMembersListView extends StatelessWidget {
  const AllMembersListView({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice,
      height: heightDevice * 0.90,
      child: ListView.builder(
        itemCount: fullMemberInfo.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MemberProfile()),
  );
                },
                child: FullMemberWidget(
                  ratingContainerColor: fullMemberInfo[index].ratingContainerColor,
                  memberImage: fullMemberInfo[index].memberImage,
                  memberName: fullMemberInfo[index].memberName,
                  trianingType: fullMemberInfo[index].trianingType,
                  memberRating: fullMemberInfo[index].memberRating,
                  experience: fullMemberInfo[index].experience,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 25),
                child: MyDivider(),
              ),
            ],
          );
        },
      ),
    );
  }
}