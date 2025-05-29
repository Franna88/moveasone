import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/userSide/Home/AdditionalResources/AdditionalResources.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/Rachelle.dart';
import 'package:move_as_one/userSide/Home/Motivational/Motivational.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkout.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/Home/WorkshopRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted>
    with SingleTickerProviderStateMixin {
  // Controllers and state variables
  late Future<Map<String, dynamic>> _headerInfoFuture;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Modern elegant color palette
  final Color primary = const Color(0xFF7FB2DE); // Cornflower Blue
  final Color secondary = const Color(0xFFCEC2EF); // Lavender
  final Color accent = const Color(0xFFE8A08C); // Light Coral
  final Color neutral = const Color(0xFFF7F5FA); // Light Background
  final Color neutralDark = const Color(0xFF3B3B3B); // Dark Text
  final Color highlight = const Color(0xFFEEE66F); // Lemon
  final Color success = const Color(0xFFB2D187); // Light Moss
  final Color info = const Color(0xFFA3E1DB); // Pale Turquoise
  final Color warm = const Color(0xFFDBA77C); // Toffee

  // Gradients
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary.withOpacity(0.8), info.withOpacity(0.7)],
      );

  LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent.withOpacity(0.8), warm.withOpacity(0.7)],
      );

  @override
  void initState() {
    super.initState();
    _headerInfoFuture = _loadHeaderInfo();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();

    // Set system UI style for a more immersive experience
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
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
        'headerText':
            data['headerText'] ?? 'You have the power to decide to be great.',
        'subtitleText': data['subtitleText'] ?? 'Let\'s start now!',
        'imageUrl': data['imageUrl'] ?? '',
      };
    } else {
      return {
        'headerText': 'You have the power to decide to be great.',
        'subtitleText': 'Let\'s start now!',
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
          return _buildLoadingScreen();
        }

        final headerText = snapshot.data?['headerText'] ??
            'You have the power to decide to be great.';
        final subtitleText =
            snapshot.data?['subtitleText'] ?? 'Let\'s start now!';
        final imageUrl = snapshot.data?['imageUrl'] ?? '';

        return Scaffold(
          backgroundColor: neutral,
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Immersive Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(headerText, subtitleText, imageUrl),
              ),

              // Content Sections
              SliverToBoxAdapter(
                child: _buildContentSections(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: neutral,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: neutral,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Preparing your journey...',
              style: TextStyle(
                color: neutralDark.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(
      String headerText, String subtitleText, String imageUrl) {
    return Container(
      height: MyUtility(context).height * 0.65,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with filter
          ClipRRect(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.5, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.darken,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildGradientBackground(),
                    )
                  : _buildGradientBackground(),
            ),
          ),

          // Content with animated entrance
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main title with animation
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
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
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle with animation
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
                    )),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0.1, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                      child: Text(
                        subtitleText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action button with animation
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                    )),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0.2, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primary, primary.withOpacity(0.7)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Action for Start Your Journey button
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const YourWorkouts(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(28),
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Start Your Journey',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),

          // Video play button
          Positioned(
            right: 24,
            top: MediaQuery.of(context).padding.top + 24,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Video play action
                          },
                          borderRadius: BorderRadius.circular(30),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.transparent,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primary.withOpacity(0.8),
            accent.withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSections() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom +
              kBottomNavigationBarHeight +
              20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section headers with content
            _buildSectionWithHeader('Rachelle', 'All shorts', Rachelle()),
            _buildSectionWithHeader(
                'Your Workouts', 'View all', YourWorkouts()),
            _buildSectionWithHeader('Motivation', 'Explore', Motivational()),
            _buildSectionWithHeader('Resources', 'More', AdditionalResources()),
            _buildSectionWithHeader(
                'Live Workshops', 'See all', _buildWorkshopsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionWithHeader(
      String title, String actionText, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: neutralDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (title == 'Your Workouts') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YourWorkouts()),
                    );
                  } else if (title == 'Motivation') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Motivational()),
                    );
                  } else if (title == 'Resources') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdditionalResources()),
                    );
                  } else if (title == 'Rachelle') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Rachelle()),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      actionText,
                      style: TextStyle(
                        color: primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildWorkshopsList() {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(left: 24),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workshops')
            .where('status', isEqualTo: 'upcoming')
            .orderBy('date', descending: false)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primary),
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: accent.withOpacity(0.7),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unable to load workshops',
                    style: TextStyle(
                      color: accent.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    color: primary.withOpacity(0.5),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No upcoming workshops',
                    style: TextStyle(
                      color: primary.withOpacity(0.7),
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
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final workshop = workshops[index].data() as Map<String, dynamic>;

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
                width: 280,
                margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: workshop['imageUrl'] != null
                            ? Image.network(
                                workshop['imageUrl'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        primary.withOpacity(0.8),
                                        secondary.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primary.withOpacity(0.8),
                                      secondary.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                      ),

                      // Overlay gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isToday ? highlight : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                isToday ? 'Today' : 'Upcoming',
                                style: TextStyle(
                                  color: isToday ? neutralDark : primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Title
                            Text(
                              workshop['title'] ?? 'Untitled Workshop',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            // Time and attendance
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  date != null
                                      ? DateFormat('MMM dd, yyyy').format(date)
                                      : 'Date TBA',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.people,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${(workshop['participants'] as List?)?.length ?? 0}/${workshop['maxParticipants'] ?? 0}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Join button
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: TextButton(
                                onPressed: () => _joinWorkshop(
                                  context,
                                  workshops[index].id,
                                  workshop['title'] ?? 'Untitled Workshop',
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: const Text(
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
    );
  }

  Future<void> _joinWorkshop(
      BuildContext context, String workshopId, String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Please sign in to join workshops', isError: true);
      return;
    }

    try {
      // Show loading indicator
      _showLoadingDialog(context);

      final workshopRef =
          FirebaseFirestore.instance.collection('workshops').doc(workshopId);
      final workshopDoc = await workshopRef.get();

      // Dismiss loading dialog
      Navigator.pop(context);

      if (!workshopDoc.exists) {
        _showSnackBar('Workshop not found', isError: true);
        return;
      }

      final workshop = workshopDoc.data() as Map<String, dynamic>;

      final currentParticipants = workshop['participants'] as List? ?? [];
      final maxParticipants = workshop['maxParticipants'] ?? 20;

      if (currentParticipants.length >= maxParticipants) {
        _showSnackBar('Workshop is full', isError: true);
        return;
      }

      final isRegistered = currentParticipants.any((p) => p['id'] == user.uid);

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

        _showSnackBar('Successfully joined workshop!');
      }

      // Navigate to workshop room
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
      _showSnackBar('Error joining workshop: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? accent : primary,
        duration: Duration(seconds: isError ? 4 : 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 16,
          right: 16,
        ),
        elevation: 4,
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Joining workshop...',
                  style: TextStyle(
                    color: neutralDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
