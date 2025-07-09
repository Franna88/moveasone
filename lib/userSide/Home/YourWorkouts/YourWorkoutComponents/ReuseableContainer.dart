import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/enhanced_workout_viewer/screens/workout_detail_viewer.dart';

class ReuseableContainer extends StatelessWidget {
  final String image;
  final String day;
  final String workout;
  final String workoutId;
  final String? workoutName; // Optional workout name field

  const ReuseableContainer({
    super.key,
    required this.image,
    required this.day,
    required this.workout,
    required this.workoutId,
    this.workoutName,
  });

  @override
  Widget build(BuildContext context) {
    // Use workout name if available, otherwise use workout (bodyArea)
    final displayName = workoutName ?? workout;

    // Check if image URL is valid
    final bool hasValidImage = image.isNotEmpty &&
        (image.startsWith('http://') || image.startsWith('https://'));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailViewer(
              workoutId: workoutId,
              userType: 'user',
            ),
          ),
        );
      },
      child: Container(
        height: MyUtility(context).height / 6.8,
        width: MyUtility(context).width / 1.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: hasValidImage ? null : Colors.grey[300],
          image: hasValidImage
              ? DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    debugPrint('Error loading image: $exception');
                  },
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              // Add placeholder icon if no valid image
              if (!hasValidImage)
                Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: Colors.grey[500],
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        color: Color(0xFF6699CC),
                        fontSize: 22,
                        fontFamily: 'Be Vietnam',
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      displayName,
                      style: TextStyle(
                        color: Color.fromARGB(199, 170, 95, 58),
                        fontSize: 16,
                        fontFamily: 'Be Vietnam',
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
