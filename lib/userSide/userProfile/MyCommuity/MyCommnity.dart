import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/Discover.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/Friends.dart';
import 'package:move_as_one/userSide/userProfile/MyCommuity/Other/FriendRequest.dart';

class MyCommunity extends StatefulWidget {
  const MyCommunity({super.key});

  @override
  State<MyCommunity> createState() => _MyCommunityState();
}

class _MyCommunityState extends State<MyCommunity>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final Color secondaryColor = const Color(0xFF7FB2DE); // Light Blue
  final Color accentColor = const Color(0xFFA3E1DB); // Pale Turquoise
  final Color backgroundColor =
      const Color(0xFFF8FFFA); // Off-white with hint of mint

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: child,
              );
            },
            child: Text(
              'MY COMMUNITY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Add search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab navigation with modern design
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavigationButton('My Friends', 0, Icons.people),
                _buildNavigationButton('Discover', 1, Icons.explore),
                _buildNavigationButton('Requests', 2, Icons.person_add),
              ],
            ),
          ),

          // Page content with animation
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
                Discover(),
                FriendRequest(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () {
          // Add friend or invite functionality
        },
        child: Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildNavigationButton(String text, int index, IconData icon) {
    final isSelected = _selectedIndex == index;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: isSelected ? 1.0 : 0.4 + (0.6 * _animationController.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          width: MyUtility(context).width / 3.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? primaryColor : Colors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? primaryColor : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 3,
                width: isSelected ? 60 : 0,
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
