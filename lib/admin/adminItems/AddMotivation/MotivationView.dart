import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationAdd.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';

class MotivationView extends StatefulWidget {
  const MotivationView({super.key});

  @override
  State<MotivationView> createState() => _MotivationViewState();
}

class _MotivationViewState extends State<MotivationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Modern color scheme
  final Color primaryColor = const Color(0xFF6A3EA1); // Purple
  final Color secondaryColor = const Color(0xFF60BFC5); // Teal
  final Color accentColor = const Color(0xFFFF7F5C); // Coral/Orange
  final Color backgroundColor = const Color(0xFFF7F5FA); // Light purple tint

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0; // Default to My Videos tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'MOTIVATION VIDEOS',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutsFullLenght()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: primaryColor),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: secondaryColor,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              onTap: (index) {
                if (index == 1) {
                  // Navigate to New Videos
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MotivationAdd()),
                  );
                }
              },
              tabs: [
                Tab(text: 'My Videos'),
                Tab(text: 'New Videos'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: Container(
              color: backgroundColor,
              child: MotivationGridView(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MotivationAdd()),
          );
        },
        backgroundColor: accentColor,
        icon: Icon(Icons.add),
        label: Text(
          'ADD NEW',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'About Motivation Videos',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                  Icons.videocam_outlined, 'Videos to inspire your members'),
              SizedBox(height: 12),
              _buildInfoRow(Icons.touch_app_outlined,
                  'Tap a video to play it fullscreen'),
              SizedBox(height: 12),
              _buildInfoRow(
                  Icons.delete_outline, 'Long press a video to delete it'),
              SizedBox(height: 12),
              _buildInfoRow(Icons.add_circle_outline,
                  'Add new videos from the New Videos tab'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              child: Text(
                'GOT IT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: secondaryColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
