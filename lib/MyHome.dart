import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/Services/debug_service.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // Color palette
  final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
  final accentColor = const Color(0xFFEDCBA4); // Toffee
  final highlightColor = const Color(0xFFF5DEB3); // Sand
  final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream

  // Handle logout
  Future<void> _handleLogout() async {
    DebugService().startPerformanceTimer('logout_process_myhome');
    DebugService()
        .log('Starting logout from MyHome', LogLevel.info, tag: 'AUTH');

    try {
      await FirebaseAuth.instance.signOut();
      DebugService().log(
          'Firebase signOut successful from MyHome', LogLevel.info,
          tag: 'AUTH');
      DebugService().logNavigation('MyHome', 'UserState');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserState()),
        (route) => false,
      );

      DebugService().log('MyHome logout completed successfully', LogLevel.info,
          tag: 'AUTH');
    } catch (e, stackTrace) {
      DebugService()
          .logError('MyHome logout failed', e, stackTrace, tag: 'AUTH');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    } finally {
      DebugService().endPerformanceTimer('logout_process_myhome');
    }
  }

  // Show logout confirmation
  void _showLogoutConfirmation() {
    DebugService().logUserAction('show_logout_confirmation', screen: 'MyHome');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get user details
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userEmail = currentUser?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Move As One',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
                image: DecorationImage(
                  image: AssetImage('images/new_photos/home_main.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    primaryColor.withOpacity(0.7),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: primaryColor,
              ),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.fitness_center,
                color: primaryColor,
              ),
              title: Text('My Workouts'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to workouts
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: primaryColor,
              ),
              title: Text('My Community'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to community
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: primaryColor,
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: BottomNavBar(),
      ),
    );
  }
}
