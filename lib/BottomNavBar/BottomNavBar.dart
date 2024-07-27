import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/myVideosGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/newVideosGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/newVideosMain.dart';
import 'package:move_as_one/userSide/Home/GetStarted.dart';
import 'package:move_as_one/userSide/UserProfile/MyCommuity/MyCommnity.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendhi5Back.dart';
import 'package:move_as_one/userSide/UserProfile/UserProfile.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoAdd.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoView.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/videoBrowsPage.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      GetStarted(),
      VideoBrowsPage(),
      MyWorkouts(),
      UserAddVideo(),
      UserProfile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildIcon(String assetPath, int index) {
    return Container(
      width: 50,
      height: 50,
      child: Center(
        child: _isSvg(assetPath)
            ? SvgPicture.asset(
                assetPath,
                color: _selectedIndex == index ? Colors.white : Colors.grey,
                width: 35,
                height: 35,
              )
            : Image.asset(
                assetPath,
                width: 40,
                height: 40,
              ),
      ),
    );
  }

  bool _isSvg(String assetPath) {
    return assetPath.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Color(0xFF006261),
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildIcon('images/Exercise.svg', 0),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('images/Video.svg', 1),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('images/Plus-Circle.svg', 2),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('images/Search.svg', 3),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18,
                backgroundImage: AssetImage('images/Avatar1.jpg'),
              ),
              // _buildIcon('images/comment1.jpg', 4),
              label: '', // Empty label
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
