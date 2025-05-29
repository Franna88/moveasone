import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/enhanced_workout_viewer/enhanced_workout_viewer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourWorkouts extends StatefulWidget {
  const YourWorkouts({super.key});

  @override
  _YourWorkoutsState createState() => _YourWorkoutsState();
}

class _YourWorkoutsState extends State<YourWorkouts>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> workoutDocuments = [];
  bool isLoading = true;
  bool isAuthChecked = false;
  late AnimationController _animationController;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF03A696);
  final Color accentColor = const Color(0xFFE6F4F1);
  final Color energyColor = const Color(0xFFF6E7CB);
  final Color backgroundColor = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Check authentication first
    _checkAuthAndActivityLevel();

    // Set a timeout to ensure loading doesn't hang
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && isLoading) {
        print("YourWorkouts: Loading timed out, using fallback data");
        setState(() {
          isLoading = false;
          // Provide some fallback data
          workoutDocuments = _getFallbackWorkouts();
        });
      }
    });

    _animationController.forward();
  }

  // Check if user is authenticated and has activity level set
  Future<void> _checkAuthAndActivityLevel() async {
    print("YourWorkouts: Checking auth status and activity level");

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("YourWorkouts: No authenticated user found");
        setState(() {
          isAuthChecked = true;
          isLoading = false;
          workoutDocuments = _getFallbackWorkouts();
        });
        return;
      }

      // Check if user has activity level
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print("YourWorkouts: User document doesn't exist");
        await _createUserWithDefaultActivityLevel(user.uid);
      } else {
        final userData = userDoc.data() as Map<String, dynamic>;
        if (userData['activityLevel'] == null ||
            userData['activityLevel'] == '') {
          print("YourWorkouts: Setting default activity level");
          await _updateUserActivityLevel(user.uid);
        }
      }

      setState(() {
        isAuthChecked = true;
      });

      // Now fetch workouts
      fetchWorkouts();
    } catch (e) {
      print("YourWorkouts: Error checking auth status: $e");
      setState(() {
        isAuthChecked = true;
        isLoading = false;
        workoutDocuments = _getFallbackWorkouts();
      });
    }
  }

  // Create a user document with default activity level
  Future<void> _createUserWithDefaultActivityLevel(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'activityLevel': 'Intermediate',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("YourWorkouts: Created user with default activity level");
    } catch (e) {
      print("YourWorkouts: Error creating user document: $e");
    }
  }

  // Update user's activity level to default
  Future<void> _updateUserActivityLevel(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'activityLevel': 'Intermediate',
      });
      print("YourWorkouts: Updated user's activity level");
    } catch (e) {
      print("YourWorkouts: Error updating activity level: $e");
    }
  }

  // Fallback workouts to show when Firebase fails
  List<Map<String, dynamic>> _getFallbackWorkouts() {
    return [
      {
        'docId': 'sample1',
        'displayImage':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        'selectedWeekdays': 'Monday, Wednesday, Friday',
        'bodyArea': 'Upper Body',
        'name': 'Strength Training',
      },
      {
        'docId': 'sample2',
        'displayImage':
            'https://images.unsplash.com/photo-1574680096145-d05b474e2155',
        'selectedWeekdays': 'Tuesday, Thursday',
        'bodyArea': 'Lower Body',
        'name': 'Leg Workout',
      },
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchWorkouts() async {
    if (!mounted) return;

    try {
      print("YourWorkouts: Fetching workouts");
      setState(() {
        isLoading = true;
      });

      // Use Firebase Auth to get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("YourWorkouts: No authenticated user found during fetch");
        setState(() {
          workoutDocuments = _getFallbackWorkouts();
          isLoading = false;
        });
        return;
      }

      // Check if user document exists with activity level
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists || userDoc.data()?['activityLevel'] == null) {
        print("YourWorkouts: User has no activity level, using fallback data");
        setState(() {
          workoutDocuments = _getFallbackWorkouts();
          isLoading = false;
        });
        return;
      }

      // Get workouts based on activity level
      final workouts = await EnhancedWorkoutViewer.getWorkoutsByActivityLevel();
      print("YourWorkouts: Got ${workouts.length} workouts");

      if (mounted) {
        setState(() {
          workoutDocuments = workouts.isNotEmpty
              ? List<Map<String, dynamic>>.from(workouts)
              : _getFallbackWorkouts();
          isLoading = false;
        });
      }
    } catch (e) {
      print("YourWorkouts: Error fetching workouts: $e");
      if (mounted) {
        setState(() {
          workoutDocuments = _getFallbackWorkouts();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.42,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 4,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Your Journey',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                _buildViewAllButton(),
              ],
            ),
          ),

          // Workout cards section
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    ),
                  )
                : workoutDocuments.isEmpty
                    ? _buildEmptyState()
                    : _buildWorkoutList(),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyWorkouts()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: secondaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View All',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: secondaryColor,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.self_improvement,
            size: 48,
            color: primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'Begin Your Wellness Journey',
            style: TextStyle(
              fontSize: 16,
              color: primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyWorkouts()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: accentColor.withOpacity(0.2),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Explore Programs',
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: workoutDocuments.length,
      itemBuilder: (context, index) {
        final delay = 0.2 + (index * 0.1);
        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay.clamp(0.0, 1.0), 1.0, curve: Curves.easeOut),
        );

        return _buildWorkoutCard(
          workoutDocuments[index]['displayImage'] ??
              'https://via.placeholder.com/150',
          workoutDocuments[index]['selectedWeekdays'] ?? 'Any Day',
          workoutDocuments[index]['bodyArea'] ?? 'Full Body',
          workoutDocuments[index]['docId'] ?? '',
          workoutDocuments[index]['name'] ?? 'Wellness Program',
          animation,
        );
      },
    );
  }

  Widget _buildWorkoutCard(String imageUrl, String day, String type,
      String workoutId, String name, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: 300,
        margin: EdgeInsets.only(right: 16, bottom: 8, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Navigate to workout detail
              },
              child: Stack(
                children: [
                  // Background image with overlay
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: [0.4, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Content overlay
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Program type badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: energyColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                color: primaryColor,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                type,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),

                        // Program details
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white.withOpacity(0.9),
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              day.length > 20
                                  ? '${day.substring(0, 20)}...'
                                  : day,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Start workout action
                                    _startWorkout(workoutId, name);
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: energyColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Begin Practice',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Bookmark action
                                  _showSnackBar('Workout saved to favorites');
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.bookmark_border_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  void _startWorkout(String workoutId, String name) {
    if (workoutId.isEmpty) {
      _showSnackBar('Unable to start workout. Try again later.');
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading your workout...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate loading (replace with actual workout loading logic)
    Future.delayed(Duration(milliseconds: 800), () {
      Navigator.pop(context); // Close the loading dialog

      // Navigate to the workout
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnhancedWorkoutViewer(
              workoutId: workoutId,
              userType: 'user',
            ),
          ),
        );
      } catch (e) {
        print("YourWorkouts: Error navigating to workout: $e");
        _showSnackBar('Error starting workout: $e');
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
