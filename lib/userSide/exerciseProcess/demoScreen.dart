import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/exerciseProcess/sceenTypes/enhancedVideoScreen.dart';

class VideoPlayerDemo extends StatelessWidget {
  const VideoPlayerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player Demo'),
        backgroundColor: UiColors().teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Try our enhanced workout video player with improved UI and controls',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDemoCard(
                  context,
                  title: 'Push-up Workout',
                  description:
                      'Basic push-up workout focusing on proper form and breathing technique',
                  workoutType: 'workouts',
                  // Sample video URL - replace with an actual workout video
                  videoUrl:
                      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                  reps: '10',
                ),
                _buildDemoCard(
                  context,
                  title: 'Light Stretching',
                  description:
                      'Warm-up stretches to prepare your body for the main workout',
                  workoutType: 'warmUp',
                  // Sample video URL - replace with an actual workout video
                  videoUrl:
                      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                  reps: '5',
                ),
                _buildDemoCard(
                  context,
                  title: 'Cool Down',
                  description:
                      'Gentle stretches to bring your heart rate down and reduce muscle soreness',
                  workoutType: 'coolDowns',
                  // Sample video URL - replace with an actual workout video
                  videoUrl:
                      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
                  reps: '3',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required String workoutType,
    required String videoUrl,
    required String reps,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => Scaffold(
                body: EnhancedVideoScreen(
                  changePageIndex: () => Navigator.pop(context),
                  videoUrl: videoUrl,
                  workoutType: workoutType,
                  title: title,
                  repsCounter: 1,
                  reps: reps,
                  description: description,
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: UiColors().primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      workoutType == 'warmUp'
                          ? 'WARM-UP'
                          : workoutType == 'workouts'
                              ? 'WORKOUT'
                              : 'COOL-DOWN',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Reps: $reps',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Play Video'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UiColors().teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => Scaffold(
                          body: EnhancedVideoScreen(
                            changePageIndex: () => Navigator.pop(context),
                            videoUrl: videoUrl,
                            workoutType: workoutType,
                            title: title,
                            repsCounter: 1,
                            reps: reps,
                            description: description,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
