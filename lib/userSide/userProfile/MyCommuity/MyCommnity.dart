import 'package:flutter/material.dart';

import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/Const/conts.dart' as consts;
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/Discover.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/Friends.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/FriendRequest.dart';

class MyCommunity extends StatefulWidget {
  const MyCommunity({super.key});

  @override
  State<MyCommunity> createState() => _MyCommunityState();
}

class _MyCommunityState extends State<MyCommunity> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'MY COMMUNITY',
            style: TextStyle(
              color: consts.textcolor,
              fontSize: 15,
              fontFamily: 'BeVietnam',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavigationButton(context, 'My Friends', 0),
              _buildNavigationButton(context, 'Discover', 1),
              _buildNavigationButton(context, 'Requests', 2),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const <Widget>[
                FriendsListPage(),
                Discover(), // Replace with your Discover widget
                FriendRequest(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, int index) {
    return Column(
      children: [
        TextButton(
          onPressed: () => _onItemTapped(index),
          style: TextButton.styleFrom(
            foregroundColor:
                _selectedIndex == index ? consts.textcolor : Color(0xFF1E1E1E),
            textStyle: TextStyle(
              fontSize: 15,
              fontFamily: 'Belight',
              fontWeight: FontWeight.w100,
            ),
          ),
          child: Text(text),
        ),
        Container(
          height: 3,
          width: MyUtility(context).width / 3.2,
          decoration: BoxDecoration(
              color: _selectedIndex == index
                  ? Color(0xFF006261)
                  : Colors.transparent),
        ),
      ],
    );
  }
}
