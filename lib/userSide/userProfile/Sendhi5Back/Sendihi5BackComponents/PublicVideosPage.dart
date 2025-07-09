import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/userSide/UserVideo/services/rebuilt_video_service.dart';

class PublicVideosPage extends StatefulWidget {
  final String userId;
  final String title;

  const PublicVideosPage({
    super.key,
    required this.userId,
    required this.title,
  });

  @override
  State<PublicVideosPage> createState() => _PublicVideosPageState();
}

class _PublicVideosPageState extends State<PublicVideosPage> {
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
        _publicVideos = videos;
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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showVideoInfo(UserVideoModel video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          video.title,
          style: TextStyle(
            fontFamily: 'BeVietnam',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video.description.isNotEmpty)
              Text(
                video.description,
                style: TextStyle(
                  fontFamily: 'BeVietnam',
                  fontSize: 14,
                ),
              ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 16,
                  color: Color(0xFF0085FF),
                ),
                SizedBox(width: 4),
                Text(
                  _formatDuration(video.duration),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0085FF),
                    fontFamily: 'BeVietnam',
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF0085FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    video.category,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0085FF),
                      fontFamily: 'BeVietnam',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF0085FF),
                fontFamily: 'BeVietnam',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(UserVideoModel video) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showVideoInfo(video),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 120,
          child: Row(
            children: [
              // Video thumbnail
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: video.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          video.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.video_library,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.video_library,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                ),
              ),

              // Video info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1E1E),
                          fontFamily: 'BeVietnam',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4),

                      // Description
                      if (video.description.isNotEmpty)
                        Text(
                          video.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'BeVietnam',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      Spacer(),

                      // Duration and category
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 16,
                            color: Color(0xFF0085FF),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDuration(video.duration),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0085FF),
                              fontFamily: 'BeVietnam',
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFF0085FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              video.category,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF0085FF),
                                fontFamily: 'BeVietnam',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF1E1E1E),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 20,
            fontFamily: 'Belight',
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0085FF)),
              ),
            )
          : _publicVideos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No public videos available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'BeVietnam',
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: Color(0xFF0085FF),
                  onRefresh: _loadPublicVideos,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: _publicVideos.length,
                    itemBuilder: (context, index) {
                      return _buildVideoCard(_publicVideos[index]);
                    },
                  ),
                ),
    );
  }
}
