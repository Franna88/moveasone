import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/WorkoutCreatorVideo/FullScreenVideoPlayer.dart';
import 'package:move_as_one/commonUi/ReusebaleImage.dart';
import 'package:move_as_one/myutility.dart';

class Rachelle extends StatefulWidget {
  const Rachelle({super.key});

  @override
  State<Rachelle> createState() => _RachelleState();
}

class _RachelleState extends State<Rachelle> {
  int _selectedIndex = -1;
  List<Map<String, String>> videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('shorts')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      videos = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'videoUrl': data['videoUrl'] as String,
          'thumbnailUrl': data['thumbnailUrl'] as String,
          'description': data['videoName'] as String,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.22,
      child: Column(
        children: [
          SizedBox(
            height: MyUtility(context).height * 0.04,
          ),
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rachelle',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontFamily: 'belight',
                  ),
                ),
                /*Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFFAA5F3A),
                    fontSize: 15,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w100,
                  ),
                )*/
              ],
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return VideoButton(
                  isSelected: _selectedIndex == index,
                  videoUrl: videos[index]['videoUrl']!,
                  thumbnailUrl: videos[index]['thumbnailUrl']!,
                  description: videos[index]['description']!,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenVideoPlayer(
                          videoUrl: videos[index]['videoUrl']!,
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
