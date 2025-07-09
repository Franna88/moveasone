import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/VideoImages.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/PublicVideosPage.dart';
import 'package:move_as_one/userSide/UserVideo/services/rebuilt_video_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/myutility.dart';

class Videos extends StatefulWidget {
  final String userId;

  const Videos({super.key, required this.userId});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  List<UserVideoModel> _publicVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPublicVideos();
  }

  Future<void> _loadPublicVideos() async {
    try {
      final videos = await _getPublicVideos(widget.userId);
      setState(() {
        _publicVideos = videos.take(3).toList(); // Show only first 3 videos
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading public videos: $e');
    }
  }

  Future<List<UserVideoModel>> _getPublicVideos(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) return [];

      final data = doc.data() ?? {};
      final videosJson =
          List<Map<String, dynamic>>.from(data['userVideos'] ?? []);

      return videosJson
          .map((json) => UserVideoModel.fromJson(json))
          .where((video) => video.isPublic)
          .toList()
        ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    } catch (e) {
      print('Error fetching public videos: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Videos',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 20,
                  fontFamily: 'Belight',
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublicVideosPage(
                        userId: widget.userId,
                        title: 'Videos',
                      ),
                    ),
                  );
                },
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFF0085FF),
                    fontSize: 15,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
        ),
        _isLoading
            ? Container(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF0085FF)),
                  ),
                ),
              )
            : _publicVideos.isEmpty
                ? Container(
                    height: 120,
                    child: Center(
                      child: Text(
                        'No public videos available',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontFamily: 'BeVietnam',
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MyUtility(context).width * 0.02,
                        ),
                        ..._publicVideos
                            .map((video) => VideoImages(
                                  image: video.thumbnailUrl,
                                ))
                            .toList(),
                        if (_publicVideos.length >= 3)
                          SizedBox(width: MyUtility(context).width * 0.02),
                      ],
                    ),
                  ),
      ],
    );
  }
}
