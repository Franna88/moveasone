import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/enhanced_workout_viewer/screens/workout_detail_viewer.dart';

class WeekdaysContainer extends StatefulWidget {
  final Function(int) changePageIndex;
  final List<Map<String, dynamic>> workoutDocuments;

  WeekdaysContainer({
    super.key,
    required this.changePageIndex,
    required this.workoutDocuments,
  });

  @override
  State<WeekdaysContainer> createState() => _WeekdaysContainerState();
}

class _WeekdaysContainerState extends State<WeekdaysContainer> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Container(
      height: heightDevice * 0.75,
      child: ListView.builder(
        itemCount: widget.workoutDocuments.length,
        itemBuilder: (context, index) {
          var workout = widget.workoutDocuments[index];
          var docId = workout['docId'];
          var warmupPhoto = workout['displayImage'];
          var selectedWeekdays = workout['selectedWeekdays'];
          var bodyArea = workout['bodyArea'];
          var name = workout['name'] ?? bodyArea; // Use name if available

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              child: GestureDetector(
                onTap: () {
                  widget.changePageIndex(1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailViewer(
                        workoutId: docId,
                        userType: 'user',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: heightDevice * 0.22,
                  width: widthDevice * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: warmupPhoto.isNotEmpty &&
                            (warmupPhoto.startsWith('http://') ||
                                warmupPhoto.startsWith('https://'))
                        ? null
                        : Colors.grey[300],
                    image: warmupPhoto.isNotEmpty &&
                            (warmupPhoto.startsWith('http://') ||
                                warmupPhoto.startsWith('https://'))
                        ? DecorationImage(
                            image: NetworkImage(warmupPhoto),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              debugPrint('Error loading image: $exception');
                            },
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      // Add placeholder icon if no valid image
                      if (warmupPhoto.isEmpty ||
                          !(warmupPhoto.startsWith('http://') ||
                              warmupPhoto.startsWith('https://')))
                        Center(
                          child: Icon(
                            Icons.fitness_center,
                            size: 48,
                            color: Colors.grey[500],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '$selectedWeekdays \n',
                                  style: TextStyle(
                                    fontFamily: 'BeVietnam',
                                    fontSize: 23,
                                    color: UiColors().brown,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                                TextSpan(
                                  text: name,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: const Color.fromARGB(170, 95, 58, 1),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
