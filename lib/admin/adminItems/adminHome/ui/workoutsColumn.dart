import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationView.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/questionsScreens/checkInQuestions.dart';
import 'package:move_as_one/enhanced_workout_creator/enhanced_workout_creator.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/videoBrowsPage.dart';

class WorkoutsColumn extends StatelessWidget {
  const WorkoutsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    // Enhanced color scheme
    final primaryColor = const Color(0xFF6A3EA1); // Purple
    final secondaryColor = const Color(0xFF60BFC5); // Teal
    final accentColor = const Color(0xFFFF7F5C); // Coral/Orange
    final backgroundColor = const Color(0xFFF7F5FA); // Light purple tint
    final highlightColor = const Color(0xFFFFA41B); // Golden/amber

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // New Workout Card with 3D effect
            _buildEnhancedCard(
              context: context,
              title: 'New Workout',
              icon: Icons.add_circle_outline,
              gradientColors: [
                secondaryColor,
                Color(0xFF4DB6BD), // Deeper teal
              ],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnhancedWorkoutCreator(),
                  ),
                );
              },
            ),

            // All Workouts Card with 3D effect
            _buildEnhancedCard(
              context: context,
              title: 'All Workouts',
              icon: Icons.fitness_center,
              gradientColors: [
                secondaryColor.withOpacity(0.9),
                secondaryColor,
              ],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoBrowsPage(),
                  ),
                );
              },
            ),

            // Check In Questions Card with 3D effect
            _buildEnhancedCard(
              context: context,
              title: 'Check In Questions',
              icon: Icons.help_outline,
              gradientColors: [
                secondaryColor.withOpacity(0.8),
                secondaryColor.withOpacity(0.9),
              ],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckInQuestions(),
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Motivation section with 3D effect
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Text(
            'Motivation',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        _buildMotivationCard(
          context: context,
          title: 'Add Motivation',
          icon: Icons.favorite_border,
          gradientColors: [
            accentColor,
            accentColor.withOpacity(0.8),
          ],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MotivationView(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(0, -2),
            blurRadius: 5,
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
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with slight shadow for 3D effect
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),

                // Title text with shadow
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
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
    );
  }

  Widget _buildMotivationCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(0, -2),
            blurRadius: 5,
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
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                children: [
                  // Icon with 3D effect
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title with shadow
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Arrow icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
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
}
