import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/allMembers.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/fullMemberWidget.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/memberCategorys.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/searchBar.dart';

class SearchMembers extends StatelessWidget {
  const SearchMembers({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return MainContainer(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              Container(
                width: widthDevice * 0.80,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'SEARCH MEMBERS',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SearchBarWidget(),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categories',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 20,
                fontFamily: 'Inter',
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: MyDivider(),
        ),
        MemberCategorys(
          categoryText: 'New members',
          onTap: () {
            //ADD ROUTE
          },
        ),
        MemberCategorys(
          categoryText: 'Watched Members',
          onTap: () {
            //ADD ROUTE
          },
        ),
        MemberCategorys(
          categoryText: '3 Days Non-Active Members',
          onTap: () {
            //ADD ROUTE
          },
        ),
        MemberCategorys(
          categoryText: 'Low motivated Members',
          onTap: () {
            //ADD ROUTE
          },
        ),
        MemberCategorys(
          categoryText: 'All Members',
          onTap: () {
            Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AllMembers()),
  );
            //ADD ROUTE
          },
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recently Active Members',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 20,
                fontFamily: 'Inter',
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FullMemberWidget(
            ratingContainerColor: UiColors().teal,
            memberImage: 'images/pfp4.png',
            memberName: 'Anika Workman',
            trianingType: 'High Intensity Training',
            memberRating: '4.8',
            experience: '7'),
        MyDivider(),
        const SizedBox(
          height: 20,
        ),
        FullMemberWidget(
            ratingContainerColor: UiColors().teal,
            memberImage: 'images/pfp5.jpeg',
            memberName: 'Abram Ekstrom',
            trianingType: 'Functional Strength',
            memberRating: '4.8',
            experience: '9')
      ],
    );
  }
}
