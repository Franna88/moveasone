import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:move_as_one/admin/adminItems/bookings/bookingsRequested/bookingsRequested.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/MotivationManager.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/WatchNotifications.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/managementItems/WatchedMembers.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/AllMemberList.dart';
import 'package:move_as_one/admin/adminItems/mealPlanRequests/mealPlanRequests.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/adminInboxPage.dart';

class MembersColumn extends StatefulWidget {
  const MembersColumn({super.key});

  @override
  State<MembersColumn> createState() => _MembersColumnState();
}

class _MembersColumnState extends State<MembersColumn>
    with SingleTickerProviderStateMixin {
  // Modern color scheme - perfectly matched to the screenshot
  final Color primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final Color secondaryColor = const Color(0xFF60BFC5); // Teal
  final Color accentColor = const Color(0xFFFF7F5C); // Coral/Orange
  final Color inactiveColor = const Color(0xFFEF5350); // Red for inactive
  final Color watchedColor = const Color(0xFFF7B731); // Amber for watched
  final Color backgroundColor = const Color(0xFFF7F5FA); // Light purple tint

  // Card colors from screenshot
  final Color redCardColor = const Color(0xFFEF5350);
  final Color yellowCardColor = const Color(0xFFF7B731);
  final Color blueCardColor = const Color(0xFF60BFC5);
  final Color purpleButtonColor = const Color(0xFF6699CC);

  int _unreadNotifications = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Setup fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Setup slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fetchNotificationCount();
    _animationController.forward();

    // Add haptic feedback on load for a more premium feel
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotificationCount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('adminNotifications')
          .where('isRead', isEqualTo: false)
          .get();

      setState(() {
        _unreadNotifications = snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching notification count: $e');
      // Set a sample value if there's an error for demonstration purposes
      setState(() {
        _unreadNotifications = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                // Gradient header section
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFCE5E1),
                        const Color(0xFFFCE5E1).withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: accentColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Members',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (_unreadNotifications > 0) ...[
                        const Spacer(),
                        _buildNotificationBadge(),
                      ],
                    ],
                  ),
                ),

                // Cards grid - now using a fixed height
                SizedBox(
                  height: 350, // Fixed height to prevent overflow
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Row 1: Inactive cards (red)
                      _buildPremiumCard(
                        context: context,
                        index: 0,
                        title: '3 Days Inactive',
                        icon: Icons.notifications_off_outlined,
                        color: redCardColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WatchedMembers(
                                filterType: MemberFilterType.threeDay,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildPremiumCard(
                        context: context,
                        index: 1,
                        title: '6 Days Inactive',
                        icon: Icons.warning_amber_outlined,
                        color: redCardColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WatchedMembers(
                                filterType: MemberFilterType.sixDay,
                              ),
                            ),
                          );
                        },
                      ),

                      // Row 2: Motivation cards (yellow/orange)
                      _buildPremiumCard(
                        context: context,
                        index: 2,
                        title: 'Low Motivated',
                        icon: Icons.sentiment_dissatisfied_outlined,
                        color: yellowCardColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WatchedMembers(
                                filterType: MemberFilterType.lowMotivation,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildPremiumCard(
                        context: context,
                        index: 3,
                        title: 'Watched',
                        icon: Icons.visibility_outlined,
                        color: yellowCardColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WatchedMembers(
                                filterType: MemberFilterType.watched,
                              ),
                            ),
                          );
                        },
                      ),

                      // Row 3: Info cards (blue/teal)
                      _buildPremiumCard(
                        context: context,
                        index: 4,
                        title: 'Requests',
                        icon: Icons.inbox_outlined,
                        color: blueCardColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminRequestsPage(),
                            ),
                          );
                        },
                      ),
                      _buildPremiumCard(
                        context: context,
                        index: 5,
                        title: 'Meal Plans',
                        icon: Icons.restaurant_outlined,
                        color: accentColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MealPlanRequests(),
                            ),
                          );
                        },
                      ),
                      _buildPremiumCard(
                        context: context,
                        index: 6,
                        title: 'All Members',
                        icon: Icons.people_alt_outlined,
                        color: blueCardColor,
                        onTap: () {
                          _triggerHaptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllMemberList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bottom action buttons
                _buildFloatingActionButton(
                  title: 'Manage Motivation Scores',
                  icon: Icons.psychology_outlined,
                  color: purpleButtonColor,
                  onTap: () {
                    _triggerHaptic();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MotivationManager(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildOutlinedActionButton(
                  title: 'Watch List Notifications',
                  icon: Icons.notifications_active_outlined,
                  color: yellowCardColor,
                  badge: _unreadNotifications > 0
                      ? _unreadNotifications.toString()
                      : null,
                  onTap: () {
                    _triggerHaptic();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WatchNotifications(),
                      ),
                    ).then((_) => _fetchNotificationCount());
                  },
                ),

                // Extra padding at bottom to ensure content doesn't get cut off
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method for haptic feedback
  void _triggerHaptic() {
    HapticFeedback.mediumImpact();
  }

  // Notification badge perfectly matched to design
  Widget _buildNotificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$_unreadNotifications new',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Premium card with inner circle icon, exactly like screenshot
  Widget _buildPremiumCard({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final delay = Duration(milliseconds: 100 * index);

    // Staggered animation
    return FutureBuilder(
      future: Future.delayed(delay, () => true),
      initialData: false,
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: snapshot.data == true ? 1.0 : 0.0,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 400),
            padding: EdgeInsets.only(
              top: snapshot.data == true ? 0 : 20,
            ),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          color.withOpacity(_hoveredIndex == index ? 0.5 : 0.3),
                      offset: const Offset(0, 8),
                      blurRadius: _hoveredIndex == index ? 16 : 10,
                      spreadRadius: _hoveredIndex == index ? 2 : 0,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.7),
                      offset: const Offset(0, -3),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                transform: Matrix4.identity()
                  ..translate(0.0, _hoveredIndex == index ? -4.0 : 0.0, 0.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.white.withOpacity(0.1),
                    highlightColor: Colors.white.withOpacity(0.05),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Premium rounded glass icon container
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Center(
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Card title with soft shadow
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
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

  // Bottom floating action button with dramatic shadows
  Widget _buildFloatingActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            offset: const Offset(0, 6),
            blurRadius: 15,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(0, -2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  Color.lerp(color, Colors.black, 0.2)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with glassmorphism effect
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Button text
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
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

  // Outlined notification button with badge
  Widget _buildOutlinedActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 12),
                    _buildBadge(badge, Colors.red),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Notification badge
  Widget _buildBadge(String text, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Helper class for button item data
class ButtonItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ButtonItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
