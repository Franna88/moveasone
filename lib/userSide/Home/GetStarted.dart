import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/userSide/Home/AdditionalResources/AdditionalResources.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/Rachelle.dart';
import 'package:move_as_one/userSide/Home/Motivational/Motivational.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkout.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/Home/WorkshopRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _headerInfoFuture;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  // Modern wellness-focused color scheme
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF03A696);
  final Color accentColor = const Color(0xFFE6F4F1);
  final Color energyColor = const Color(0xFFF6E7CB);
  final Color backgroundColor = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    _headerInfoFuture = _loadHeaderInfo();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadHeaderInfo() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('updateHeader')
        .doc('headerInfo')
        .get();

    if (document.exists) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return {
        'headerText': data['headerText'] ?? 'Transform Your Journey',
        'subtitleText': data['subtitleText'] ??
            'Discover the perfect balance of strength and serenity',
        'imageUrl': data['imageUrl'] ?? '',
      };
    } else {
      return {
        'headerText': 'Transform Your Journey',
        'subtitleText': 'Discover the perfect balance of strength and serenity',
        'imageUrl': '',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _headerInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        final headerText =
            snapshot.data?['headerText'] ?? 'Transform Your Journey';
        final subtitleText = snapshot.data?['subtitleText'] ??
            'Discover the perfect balance of strength and serenity';
        final imageUrl = snapshot.data?['imageUrl'] ?? '';

        return Container(
          color: backgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: [
              // Modern Hero Section
              SliverToBoxAdapter(
                child: Container(
                  height: MyUtility(context).height * 0.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image with Gradient
                      ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.darken,
                        child: Image.network(
                          imageUrl.isNotEmpty
                              ? imageUrl
                              : 'https://example.com/default-wellness-image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Content Overlay
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Animated Header Text
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.easeOut,
                              )),
                              child: FadeTransition(
                                opacity: _animationController,
                                child: Text(
                                  headerText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Animated Subtitle
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _animationController,
                                curve:
                                    Interval(0.2, 1.0, curve: Curves.easeOut),
                              )),
                              child: FadeTransition(
                                opacity: _animationController,
                                child: Text(
                                  subtitleText,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32),

                            // Action Buttons
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _animationController,
                                curve:
                                    Interval(0.4, 1.0, curve: Curves.easeOut),
                              )),
                              child: FadeTransition(
                                opacity: _animationController,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: energyColor,
                                          foregroundColor: primaryColor,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          "Start Your Journey",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.play_arrow_rounded,
                                            color: Colors.white),
                                        iconSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content Section
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom +
                          kBottomNavigationBarHeight),
                  child: Column(
                    children: [
                      // Quick Stats Section
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Row(
                          children: [
                            _buildQuickStat(
                              icon: Icons.self_improvement,
                              title: "Today's Focus",
                              value: 'Mindfulness',
                              color: accentColor,
                            ),
                            SizedBox(width: 16),
                            _buildQuickStat(
                              icon: Icons.local_fire_department_rounded,
                              title: 'Energy',
                              value: 'High',
                              color: energyColor,
                            ),
                          ],
                        ),
                      ),

                      // Main Sections
                      Rachelle(),
                      SizedBox(height: 20),
                      YourWorkouts(),
                      SizedBox(height: 20),
                      Motivational(),
                      SizedBox(height: 20),
                      AdditionalResources(),
                      SizedBox(height: 20),
                      WorkshopSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkshopSection extends StatelessWidget {
  const WorkshopSection({super.key});

  Future<void> _joinWorkshop(
      BuildContext context, String workshopId, String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in to join workshops'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final workshopRef =
          FirebaseFirestore.instance.collection('workshops').doc(workshopId);
      final workshopDoc = await workshopRef.get();

      if (!workshopDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Workshop not found'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final workshop = workshopDoc.data() as Map<String, dynamic>;

      if (workshop['participants']?.length >= workshop['maxParticipants']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Workshop is full'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final isRegistered =
          workshop['participants']?.any((p) => p['id'] == user.uid) ?? false;

      if (!isRegistered) {
        await workshopRef.update({
          'participants': FieldValue.arrayUnion([
            {
              'id': user.uid,
              'name': user.displayName ?? 'Anonymous',
              'email': user.email,
              'joinedAt': FieldValue.serverTimestamp(),
            }
          ]),
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkshopRoom(
            workshopId: workshopId,
            workshopTitle: title,
            isHost: false,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining workshop: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE6F4F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.video_call,
                  color: Color(0xFF025959),
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Live Workshops',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF025959),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Workshops List
          SizedBox(
            height: 180,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workshops')
                  .where('status', isEqualTo: 'upcoming')
                  .orderBy('date', descending: false)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Workshop loading error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.withOpacity(0.7),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Unable to load workshops',
                          style: TextStyle(
                            color: Colors.red.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF025959)),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          color: Color(0xFF025959).withOpacity(0.5),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No upcoming workshops',
                          style: TextStyle(
                            color: Color(0xFF025959).withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final workshops = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workshops.length,
                  itemBuilder: (context, index) {
                    final workshop =
                        workshops[index].data() as Map<String, dynamic>;

                    DateTime? date;
                    try {
                      date = (workshop['date'] as Timestamp?)?.toDate();
                    } catch (e) {
                      print('Error parsing date: $e');
                    }

                    final isToday = date != null &&
                        date.day == DateTime.now().day &&
                        date.month == DateTime.now().month &&
                        date.year == DateTime.now().year;

                    return Container(
                      width: 260,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF025959),
                            Color(0xFF03A696),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF025959).withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Background Image with Overlay
                            if (workshop['imageUrl'] != null)
                              Positioned.fill(
                                child: Image.network(
                                  workshop['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Color(0xFF025959),
                                  ),
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),

                            // Content
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Status & Participants
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isToday
                                              ? Color(0xFF94FBAB)
                                                  .withOpacity(0.9)
                                              : Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isToday ? 'Today' : 'Upcoming',
                                          style: TextStyle(
                                            color: Color(0xFF025959),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${(workshop['participants'] as List?)?.length ?? 0}/${workshop['maxParticipants'] ?? 0}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Spacer(),

                                  // Title & Time
                                  Text(
                                    workshop['title'] ?? 'Untitled Workshop',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        date != null
                                            ? DateFormat('MMM dd, yyyy')
                                                .format(date)
                                            : 'Date TBA',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        workshop['time'] ?? 'Time TBA',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),

                                  // Join Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => _joinWorkshop(
                                        context,
                                        workshops[index].id,
                                        workshop['title'] ??
                                            'Untitled Workshop',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Color(0xFF025959),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Join Workshop',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
