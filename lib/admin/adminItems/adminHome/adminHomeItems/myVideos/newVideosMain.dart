import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/newVideosGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';

class NewVideosMain extends StatefulWidget {
  const NewVideosMain({super.key});

  @override
  State<NewVideosMain> createState() => _NewVideosMainState();
}

class _NewVideosMainState extends State<NewVideosMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Modern blue color scheme
  final Color primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final Color secondaryColor = const Color(0xFF7FB2DE); // Light Blue
  final Color accentColor = const Color(0xFF6699CC); // Primary Blue
  final Color backgroundColor = const Color(0xFFF8FBFF); // Light blue tint

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1; // Default to New Videos tab
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
          'ADD SHORT',
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
                if (index == 0) {
                  // Navigate to My Videos
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyVideosMain()),
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
              child: NewVideosGridView(),
            ),
          ),

          // Upload button at bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                // Same functionality as before
                NewVideosGridView.of(context)?.uploadImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutsFullLenght()),
                );
              },
              icon: Icon(Icons.cloud_upload),
              label: Text(
                'UPLOAD TO APP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
