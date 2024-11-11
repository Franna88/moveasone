import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/profileAboutPages/aboutPage.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/profileAboutItems/profileAboutPages/messagesPage.dart';
import 'package:move_as_one/commonUi/trainerRatingContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: Container(
          height: heightDevice,
          width: widthDevice,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/commonImg.png'),
                fit: BoxFit.fitHeight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: widthDevice,
                height: heightDevice * 0.65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lena Rosser',
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          TrainerRatingContainer(
                              color: UiColors().teal, rating: '4.7')
                        ],
                      ),
                    ),
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: UiColors().teal,
                      indicatorWeight: 3,
                      labelColor: UiColors().teal,
                      tabs: [
                        Tab(
                          text: 'About',
                        ),
                        Tab(
                          text: 'Likes',
                        ),
                        Tab(
                          text: 'Messages',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AboutPage(),
                          Text('Likes'),
                          MessagesPage()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
