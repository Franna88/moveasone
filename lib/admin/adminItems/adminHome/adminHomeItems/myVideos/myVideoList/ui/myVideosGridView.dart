import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/WorkoutCreatorVIdeo/FullScreenVideoPlayer.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/DeleteButtonPopup.dart';

class MyVideoGridView extends StatefulWidget {
  const MyVideoGridView({super.key});

  @override
  State<MyVideoGridView> createState() => _MyVideoGridViewState();
}

class _MyVideoGridViewState extends State<MyVideoGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future<QuerySnapshot> _videoFuture;
  bool isLoading = false;
  double progress = 0.0;

  // Modern color scheme to match other pages
  final Color primaryColor = const Color(0xFF6A3EA1); // Purple
  final Color secondaryColor = const Color(0xFF60BFC5); // Teal
  final Color accentColor = const Color(0xFFFF7F5C); // Coral/Orange
  final Color backgroundColor = const Color(0xFFF7F5FA); // Light purple tint

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
    _videoFuture = FirebaseFirestore.instance.collection('shorts').get();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshVideos() {
    setState(() {
      _videoFuture = FirebaseFirestore.instance.collection('shorts').get();
    });
  }

  Future<void> _showEditDialog(String videoId, String currentName) async {
    TextEditingController _controller =
        TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Video',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Video Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: primaryColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('shorts')
                      .doc(videoId)
                      .update({'videoName': _controller.text});
                  _refreshVideos();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('SAVE'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDeleteDialog(context, videoId, _refreshVideos);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<QuerySnapshot>(
              future: _videoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading videos...',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                var videos = snapshot.data!.docs;

                return GridView.builder(
                  itemCount: videos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    var video = videos[index];
                    var videoId = video.id;
                    var thumbnailUrl = video['thumbnailUrl'];
                    var videoName = video['videoName'];
                    var videoUrl = video['videoUrl'];

                    return _buildVideoCard(
                      videoId: videoId,
                      thumbnailUrl: thumbnailUrl,
                      videoName: videoName,
                      videoUrl: videoUrl,
                    );
                  },
                );
              },
            ),
          ),
          builder: (context, child) => FadeTransition(
            opacity: _animationController,
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.videocam_off_outlined,
              size: 64,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Videos Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first short video on the New Videos tab',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard({
    required String videoId,
    required String thumbnailUrl,
    required String videoName,
    required String videoUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenVideoPlayer(
                    videoUrl: videoUrl,
                  ),
                ),
              );
            },
            onLongPress: () {
              _showEditDialog(videoId, videoName);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail with play icon overlay
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Thumbnail
                      Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          );
                        },
                      ),
                      // Play icon overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      // Delete button in top right
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            showDeleteDialog(context, videoId, _refreshVideos);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      // Play icon
                      Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    videoName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
