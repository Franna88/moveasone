import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/newVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/writeAMessage.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workshopSection.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/MembersColumn.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/UpdateHeader.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/messagesColumn.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/workoutsColumn.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/Services/debug_service.dart';

class WorkoutsFullLenght extends StatefulWidget {
  const WorkoutsFullLenght({super.key});

  @override
  State<WorkoutsFullLenght> createState() => _WorkoutsFullLenghtState();
}

class _WorkoutsFullLenghtState extends State<WorkoutsFullLenght>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Enhanced color palette inspired by spiral logo - more vibrant and striking
  final primaryColor =
      const Color(0xFF6699CC); // Cornflower Blue - primary brand
  final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise - accent
  final accentColor = const Color(0xFFEDCBA4); // Toffee - energizing accent
  final subtleColor = const Color(0xFFF5DEB3); // Peach/Sand - background hint
  final backgroundColor =
      const Color(0xFFFFF8F0); // Light Sand/Cream - off-white
  final darkColor = const Color(0xFF5980B5); // Deeper Cornflower - for depth

  // Card theme colors - softer wellness spectrum
  final breatheCardColor = const Color(0xFF94D8E0); // Pale Turquoise
  final flowCardColor = const Color(0xFF6699CC); // Cornflower Blue
  final powerCardColor = const Color(0xFF5980B5); // Deeper Cornflower
  final balanceCardColor = const Color(0xFFEDCBA4); // Toffee
  final restoreCardColor = const Color(0xFFF5DEB3); // Sand
  final focusCardColor = const Color(0xFFEFC8A0); // Peach

  final double cardBorderRadius = 24.0;
  final double contentPadding = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Handle logout
  Future<void> _handleLogout() async {
    DebugService().startPerformanceTimer('logout_process_admin');
    DebugService().log('Starting logout from Admin Dashboard', LogLevel.info,
        tag: 'AUTH');

    try {
      await FirebaseAuth.instance.signOut();
      DebugService().log(
          'Firebase signOut successful from Admin Dashboard', LogLevel.info,
          tag: 'AUTH');
      DebugService().logNavigation('AdminDashboard', 'UserState');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserState()),
        (route) => false,
      );

      DebugService().log('Admin logout completed successfully', LogLevel.info,
          tag: 'AUTH');
    } catch (e, stackTrace) {
      DebugService()
          .logError('Admin logout failed', e, stackTrace, tag: 'AUTH');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    } finally {
      DebugService().endPerformanceTimer('logout_process_admin');
    }
  }

  // Show logout confirmation
  void _showLogoutConfirmation() {
    DebugService()
        .logUserAction('show_logout_confirmation', screen: 'AdminDashboard');
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
              onPressed: () {
                DebugService()
                    .logUserAction('cancel_logout', screen: 'AdminDashboard');
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                DebugService()
                    .logUserAction('confirm_logout', screen: 'AdminDashboard');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            color: darkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Logout button in AppBar
          IconButton(
            icon: Icon(
              Icons.logout,
              color: primaryColor,
            ),
            onPressed: _showLogoutConfirmation,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              subtleColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements - spiral patterns
              Positioned(
                top: -120,
                right: -100,
                child: _buildBackgroundSpiral(
                    250, secondaryColor.withOpacity(0.05), 4),
              ),
              Positioned(
                bottom: -150,
                left: -120,
                child: _buildBackgroundSpiral(
                    300, primaryColor.withOpacity(0.05), 3.5),
              ),

              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo and brand
                  Container(
                    margin: EdgeInsets.fromLTRB(contentPadding, contentPadding,
                        contentPadding, contentPadding),
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: darkColor.withOpacity(0.15),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background with UpdateHeader component
                          Positioned.fill(
                            child: Stack(
                              children: [
                                const UpdateHeader(),
                              ],
                            ),
                          ),

                          // Logo overlay with more visual impact
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.asset(
                                'images/MAO_logo_new.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Gradient overlay for better text visibility
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  darkColor.withOpacity(0.2),
                                  secondaryColor.withOpacity(0.3),
                                ],
                                stops: [0.3, 1.0],
                              ),
                            ),
                          ),

                          // Edit button with glow effect
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WriteAMessage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: secondaryColor.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: primaryColor,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Add logout button in header
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: _showLogoutConfirmation,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: secondaryColor.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Section Title with enhanced animation
                  Padding(
                    padding: EdgeInsets.only(
                        left: contentPadding,
                        right: contentPadding,
                        bottom: contentPadding / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'MINDFUL',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: darkColor,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'MOVEMENT',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.2,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              width: 200 * _animationController.value,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [accentColor, secondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Main content area with wellness dashboard grid
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: contentPadding),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        physics: BouncingScrollPhysics(),
                        children: [
                          // Breathe tile (Meditation)
                          _buildDashboardCard(
                            title: 'MEDITATION',
                            description: 'Meditation & Mindfulness',
                            icon: Icons.self_improvement,
                            iconColor: Colors.white,
                            cardColor: breatheCardColor,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MotivationView()),
                            ),
                          ),

                          // Flow tile (Workouts)
                          _buildDashboardCard(
                            title: 'TRAINING',
                            description: 'Dynamic Workouts',
                            icon: Icons.directions_run,
                            iconColor: Colors.white,
                            cardColor: flowCardColor,
                            onTap: () => _showSection(
                                WorkoutsColumn(), 'MINDFUL TRAINING'),
                          ),

                          // Power tile (Strength)
                          _buildDashboardCard(
                            title: 'VIDS',
                            description: 'Strength & Conditioning',
                            icon: Icons.fitness_center,
                            iconColor: Colors.white,
                            cardColor: powerCardColor,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyVideosMain()),
                            ),
                          ),

                          // Balance tile (Yoga)
                          _buildDashboardCard(
                            title: 'MEMBERS',
                            description: 'Yoga & Flexibility',
                            icon: Icons.accessibility_new,
                            iconColor: Colors.white,
                            cardColor: balanceCardColor,
                            onTap: () =>
                                _showSection(MembersColumn(), 'MOVE TOGETHER'),
                          ),

                          // Restore tile (Recovery)
                          _buildDashboardCard(
                            title: 'MESSAGES',
                            description: 'Recovery & Messaging',
                            icon: Icons.message_outlined,
                            iconColor: Colors.white,
                            cardColor: restoreCardColor,
                            onTap: () => _showSection(
                                MessagesColumn(), 'MESSAGES & UPDATES'),
                          ),

                          // Focus tile (Goals)
                          _buildDashboardCard(
                            title: 'WORKSHOPS',
                            description: 'Schedule & Manage Live Sessions',
                            icon: Icons.video_call,
                            iconColor: Colors.white,
                            cardColor: focusCardColor,
                            onTap: () => _showSection(
                                WorkshopSection(), 'WORKSHOP MANAGEMENT'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCustomFAB(),
      endDrawer: _buildLogoutDrawer(),
    );
  }

  // Add a drawer with logout option
  Widget _buildLogoutDrawer() {
    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
                image: DecorationImage(
                  image: AssetImage('images/MAO_logo_new.jpeg'),
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
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'Admin User',
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
    );
  }

  Widget _buildCustomFAB() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + 0.05 * sin(2 * pi * _animationController.value),
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () => _showAddOptions(context),
              backgroundColor: primaryColor,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [secondaryColor, primaryColor],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _animationController.value)),
          child: Opacity(
            opacity: _animationController.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withOpacity(0.3),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cardBorderRadius),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cardColor,
                            HSLColor.fromColor(cardColor)
                                .withLightness(
                                    HSLColor.fromColor(cardColor).lightness *
                                        0.8)
                                .toColor(),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon with glow
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              size: 30,
                              color: iconColor,
                            ),
                          ),
                          const Spacer(),
                          // Title and description
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSection(Widget section, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: darkColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Draggable handle and title
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(
                    bottom: BorderSide(
                      color: subtleColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 5,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.all(20.0),
                  child: section,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: darkColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, -1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 8, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              'CREATE NEW',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 24),
            _buildActionTile(
              icon: Icons.directions_run,
              title: 'New Workout',
              subtitle: 'Create a flow sequence',
              color: flowCardColor,
              onTap: () {
                Navigator.pop(context);
                _showSection(WorkoutsColumn(), 'CREATE WORKOUT');
              },
            ),
            _buildActionTile(
              icon: Icons.self_improvement,
              title: 'New Meditation',
              subtitle: 'Guide mindfulness practice',
              color: breatheCardColor,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MotivationView()),
                );
              },
            ),
            _buildActionTile(
              icon: Icons.fitness_center,
              title: 'New Strength Session',
              subtitle: 'Build power workouts',
              color: powerCardColor,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewVideosMain()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon with gradient background
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color,
                          HSLColor.fromColor(color)
                              .withLightness(
                                  HSLColor.fromColor(color).lightness * 0.8)
                              .toColor(),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: darkColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: subtleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Background spiral decoration
  Widget _buildBackgroundSpiral(double size, Color color, double rotations) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SpiralPainter(
          color: color,
          strokeWidth: 8.0,
          rotations: rotations,
        ),
      ),
    );
  }
}

// Custom painter for the spiral logo
class SpiralPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double rotations;

  SpiralPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.rotations = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    Path path = Path();
    path.moveTo(center.dx, center.dy);

    for (double i = 0; i < rotations * pi * 2; i += 0.05) {
      double factor = i / (rotations * pi * 2);
      double x = center.dx + radius * factor * cos(i);
      double y = center.dy + radius * factor * sin(i);
      path.lineTo(x, y);
    }

    // Add shimmer/glow effect
    if (strokeWidth > 2.0) {
      final Paint glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.8);

      canvas.drawPath(path, glowPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SpiralPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.rotations != rotations;
}

// Custom painter for circular text
class CircularTextPainter extends CustomPainter {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  CircularTextPainter({
    required this.text,
    required this.color,
    required this.fontSize,
    this.fontWeight = FontWeight.w600,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.45;
    final center = Offset(size.width / 2, size.height / 2);

    // Add a subtle glow/shadow to text
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    for (int i = 0; i < text.length; i++) {
      final double angle = pi / 2 + (2 * pi / text.length) * i;

      // Calculate positions for each character
      final double x = center.dx + radius * cos(angle);
      final double y = center.dy - radius * sin(angle);

      // Create text painters for shadow and text
      final shadowTextPainter = TextPainter(
        text: TextSpan(
          text: text[i],
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: text[i],
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      shadowTextPainter.layout();
      textPainter.layout();

      // Draw shadow slightly offset
      canvas.save();
      canvas.translate(x + 1, y + 1);
      canvas.rotate(angle + pi / 2);
      canvas.translate(-shadowTextPainter.width / 2, 0);
      shadowTextPainter.paint(canvas, Offset.zero);
      canvas.restore();

      // Draw text
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + pi / 2);
      canvas.translate(-textPainter.width / 2, 0);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CircularTextPainter oldDelegate) =>
      oldDelegate.text != text ||
      oldDelegate.color != color ||
      oldDelegate.fontSize != fontSize ||
      oldDelegate.fontWeight != fontWeight;
}
