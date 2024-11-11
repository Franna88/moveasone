import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_as_one/userSide/Home/GetStarted.dart';
import 'package:move_as_one/userSide/UserProfile/UserProfile.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoAdd.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoView.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/MyCommnity.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/AllMessagesDisplay.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex; // New parameter to set the starting index

  const BottomNavBar({Key? key, this.initialIndex = 0})
      : super(key: key); // Default index is 0

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex; // Index for BottomNavigationBar items

  late List<Widget> _pages; // List of all pages

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex < 5
        ? widget.initialIndex
        : 0; // Set the initial index and validate

    // List of all pages including hidden ones
    _pages = [
      GetStarted(),
      UserAddVideo(onNavigateToMyVideos: () {
        _onDirectItemTapped(5); // Navigate directly to UserVideoView (index 5)
      }),
      AllMessagesDisplay(),
      MyCommunity(),
      UserProfile(),
      Uservideoview(onNavigateToNewVideos: () {
        _onDirectItemTapped(1); // Navigate back to UserAddVideo (index 1)
      }),
    ];
  }

  // Method for handling direct navigation to hidden pages (UserVideoView)
  void _onDirectItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index; // Update selected index to navigate
      });
    } else {
      print("Invalid index: $index");
    }
  }

  // Method for handling navigation between visible BottomNavigationBar items
  void _onItemTapped(int index) {
    if (index >= 0 && index < 5) {
      // Only allow navigation for visible items (0-4)
      setState(() {
        _selectedIndex = index;
      });
    } else {
      print("Invalid BottomNavigationBar index: $index");
    }
  }

  // Helper method to build icons for BottomNavigationBar
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

  // Check if the icon is an SVG file
  bool _isSvg(String assetPath) {
    return assetPath.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Color(0xFF006261), // Original canvas background color
      ),
      home: Scaffold(
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF006261), // Restore background color
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
              label: '', // Empty label
            ),
          ],
          currentIndex: _selectedIndex < 5
              ? _selectedIndex
              : 0, // Ensure the index is valid
          selectedItemColor: Colors.white, // Selected icon color
          unselectedItemColor: Colors.grey, // Unselected icon color
          onTap: _onItemTapped, // Handle tapping on BottomNavigationBar items
        ),
      ),
    );
  }
}
