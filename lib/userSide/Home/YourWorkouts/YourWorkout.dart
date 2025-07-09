import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/enhanced_workout_viewer/enhanced_workout_viewer.dart';
import 'package:move_as_one/userSide/workouts/workoutItems/MyWorkouts/myWorkouts.dart';

class YourWorkouts extends StatefulWidget {
  const YourWorkouts({super.key});

  @override
  _YourWorkoutsState createState() => _YourWorkoutsState();
}

class _YourWorkoutsState extends State<YourWorkouts>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> workoutDocuments = [];
  bool isLoading = true;
  late AnimationController _animationController;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF6699CC);
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
    fetchWorkouts();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchWorkouts() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Add debug print to identify where the issue might be
      print("YourWorkout: Starting to fetch workouts");

      // Add a timeout to prevent infinite loading
      bool timeoutTriggered = false;
      Future.delayed(Duration(seconds: 5), () {
        if (mounted && isLoading) {
          print("YourWorkout: Timeout triggered - showing fallback data");
          timeoutTriggered = true;
          setState(() {
            isLoading = false;
            // Provide fallback workout data
            workoutDocuments = [
              {
                'docId': 'fallback1',
                'displayImage':
                    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
                'selectedWeekdays': 'Monday, Wednesday, Friday',
                'bodyArea': 'Full Body',
                'name': 'Beginner Workout',
              },
              {
                'docId': 'fallback2',
                'displayImage':
                    'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
                'selectedWeekdays': 'Tuesday, Thursday',
                'bodyArea': 'Core Focus',
                'name': 'Strength Training',
              },
            ];
          });
        }
      });

      final workouts = await EnhancedWorkoutViewer.getWorkoutsByActivityLevel();
      print("YourWorkout: Received ${workouts.length} workouts from service");

      // Don't update if timeout already happened
      if (timeoutTriggered) return;

      if (mounted) {
        if (workouts.isEmpty) {
          print("YourWorkout: No workouts returned, using fallback data");
          setState(() {
            workoutDocuments = [
              {
                'docId': 'fallback1',
                'displayImage':
                    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
                'selectedWeekdays': 'Monday, Wednesday, Friday',
                'bodyArea': 'Full Body',
                'name': 'Beginner Workout',
              },
              {
                'docId': 'fallback2',
                'displayImage':
                    'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
                'selectedWeekdays': 'Tuesday, Thursday',
                'bodyArea': 'Core Focus',
                'name': 'Strength Training',
              },
            ];
            isLoading = false;
          });
        } else {
          setState(() {
            workoutDocuments = List<Map<String, dynamic>>.from(workouts);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("YourWorkout: Error fetching workouts: $e");

      if (mounted) {
        setState(() {
          // Provide fallback workout data on error
          workoutDocuments = [
            {
              'docId': 'fallback1',
              'displayImage':
                  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
              'selectedWeekdays': 'Monday, Wednesday, Friday',
              'bodyArea': 'Full Body',
              'name': 'Beginner Workout',
            },
            {
              'docId': 'fallback2',
              'displayImage':
                  'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
              'selectedWeekdays': 'Tuesday, Thursday',
              'bodyArea': 'Core Focus',
              'name': 'Strength Training',
            },
          ];
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
                _navigateToWorkoutDetail(workoutId, name);
              },
              child: Stack(
                children: [
                  // Background image with overlay
                  Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image with fallback
                        imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print(
                                      "YourWorkout: Error loading image: $error");
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          primaryColor.withOpacity(0.7),
                                          secondaryColor.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primaryColor.withOpacity(0.7),
                                      secondaryColor.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                        // Gradient overlay
                        Container(
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
                      ],
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
                              child: GestureDetector(
                                onTap: () {
                                  _startWorkout(workoutId, name);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: energyColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                _saveWorkout(workoutId);
                              },
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

  // Navigation functions
  void _navigateToWorkoutDetail(String workoutId, String name) {
    print("YourWorkout: Navigating to workout detail: $workoutId");
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWorkouts(),
        ),
      );
    } catch (e) {
      print("YourWorkout: Navigation error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open workout details. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startWorkout(String workoutId, String name) {
    print("YourWorkout: Starting workout: $workoutId");
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Starting workout: $name'),
          backgroundColor: secondaryColor,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWorkouts(),
        ),
      );
    } catch (e) {
      print("YourWorkout: Start workout error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not start workout. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveWorkout(String workoutId) {
    print("YourWorkout: Saving workout: $workoutId");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout saved to favorites'),
        backgroundColor: secondaryColor,
      ),
    );
  }
}
