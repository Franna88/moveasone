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
    final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
    final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
    final accentColor = const Color(0xFFEDCBA4); // Toffee
    final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream
    final highlightColor = const Color(0xFFF5DEB3); // Sand

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
                primaryColor,
                secondaryColor,
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
                secondaryColor,
                primaryColor.withOpacity(0.9),
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
                accentColor,
                highlightColor,
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        _buildMotivationCard(
          context: context,
          title: 'Add Motivation',
          icon: Icons.favorite_border,
          gradientColors: [
            secondaryColor,
            primaryColor,
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),

                // Title text
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  // Icon with container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const Spacer(),

                  // Arrow icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
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
