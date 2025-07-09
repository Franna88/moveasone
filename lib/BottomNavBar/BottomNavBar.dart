import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_as_one/userSide/Home/GetStarted.dart';
import 'package:move_as_one/userSide/UserProfile/UserProfile.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoAdd.dart';

import 'package:move_as_one/userSide/userProfile/MyCommuity/MyCommnity.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/AllMessagesDisplay.dart';
import 'dart:ui';

class BottomNavBar extends StatefulWidget {
  final int initialIndex; // New parameter to set the starting index

  const BottomNavBar({Key? key, this.initialIndex = 0})
      : super(key: key); // Default index is 0

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex; // Index for BottomNavigationBar items
  late List<Widget> _pages; // List of all pages
  late AnimationController _animationController;

  // Modern blue color scheme
  final Color primaryColor =
      const Color(0xFF6699CC); // Cornflower Blue - primary brand
  final Color secondaryColor = const Color(0xFF7FB2DE); // Light Blue - accent
  final Color accentColor =
      const Color(0xFFA3E1DB); // Pale Turquoise - energizing accent
  final Color subtleColor =
      const Color(0xFFE3F2FD); // Ice Blue - background hint
  final Color backgroundColor =
      const Color(0xFFF8FBFF); // Off-white with hint of blue

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex < 5
        ? widget.initialIndex
        : 0; // Set the initial index and validate

    // Animation controller for smooth transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    // List of all pages
    _pages = [
      GetStarted(),
      UserAddVideo(),
      AllMessagesDisplay(),
      MyCommunity(),
      UserProfile(),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method for handling direct navigation between pages
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
        // Trigger animation effect when changing tabs
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      print("Invalid BottomNavigationBar index: $index");
    }
  }

  // Helper method to build icons for BottomNavigationBar with wellness theme
  Widget _buildIcon(String assetPath, int index) {
    final bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Center(
        child: _isSvg(assetPath)
            ? SvgPicture.asset(
                assetPath,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                width: isSelected ? 28 : 24,
                height: isSelected ? 28 : 24,
              )
            : Image.asset(
                assetPath,
                width: isSelected ? 32 : 28,
                height: isSelected ? 32 : 28,
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
        canvasColor: primaryColor,
      ),
      home: Scaffold(
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _pages[
              _selectedIndex], // Display the selected page with animation
        ),
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: _buildIcon('images/Exercise.svg', 0),
                        label: '',
                        tooltip: 'Workouts',
                      ),
                      BottomNavigationBarItem(
                        icon: _buildIcon('images/Video.svg', 1),
                        label: '',
                        tooltip: 'Uploaded Videos',
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 60,
                          width: 60,
                          child: Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.4),
                                    accentColor.withOpacity(0.8)
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 1.5,
                                ),
                              ),
                              child: SvgPicture.asset(
                                'images/Plus-Circle.svg',
                                color: Colors.white,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                        label: '',
                        tooltip: 'Add',
                      ),
                      BottomNavigationBarItem(
                        icon: _buildIcon('images/Search.svg', 3),
                        label: '',
                        tooltip: 'Community',
                      ),
                      BottomNavigationBarItem(
                        icon: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedIndex == 4
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: _selectedIndex == 4
                                ? [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: _selectedIndex == 4 ? 20 : 18,
                            backgroundImage: AssetImage('images/Avatar1.jpg'),
                          ),
                        ),
                        label: '',
                        tooltip: 'Profile',
                      ),
                    ],
                    currentIndex: _selectedIndex < 5
                        ? _selectedIndex
                        : 0, // Ensure the index is valid
                    selectedItemColor: Colors.white, // Selected icon color
                    unselectedItemColor:
                        Colors.white.withOpacity(0.7), // Unselected icon color
                    onTap:
                        _onItemTapped, // Handle tapping on BottomNavigationBar items
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
