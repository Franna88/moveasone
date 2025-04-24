import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/WorkoutCreatorVIdeo/FullScreenVideoPlayer.dart';

class MotivationGridView extends StatefulWidget {
  const MotivationGridView({super.key});

  @override
  State<MotivationGridView> createState() => _MotivationGridViewState();
}

class _MotivationGridViewState extends State<MotivationGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future<QuerySnapshot> _videoFuture;
  bool isLoading = false;
  double progress = 0.0;
  double imageUploadProgress = 0.0;

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
    _videoFuture = FirebaseFirestore.instance.collection('motivation').get();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshVideos() {
    setState(() {
      _videoFuture = FirebaseFirestore.instance.collection('motivation').get();
    });
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
                    var imageUrl =
                        video['imageUrl'] ?? ''; // Optional cover image
                    var videoName = video['videoName'];
                    var videoUrl = video['videoUrl'];

                    return _buildVideoCard(
                      videoId: videoId,
                      thumbnailUrl: thumbnailUrl,
                      imageUrl: imageUrl,
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
        if (isLoading) _buildLoadingOverlay(),
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
            'Add your first motivation video on the New Videos tab',
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
    required String imageUrl,
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
              _showDeleteConfirmation(context, videoId);
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
                        imageUrl.isNotEmpty ? imageUrl : thumbnailUrl,
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
                      Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      // Delete hint
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Tooltip(
                            message: 'Long press to delete',
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white.withOpacity(0.8),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Video title
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Motivation Video',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String videoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Video?',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'This video will be permanently removed from your motivation collection.',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteVideo(videoId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
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

  void _deleteVideo(String videoId) {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('motivation')
        .doc(videoId)
        .delete()
        .then((_) {
      setState(() {
        isLoading = false;
      });
      _refreshVideos();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting video: $error'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                SizedBox(height: 16),
                Text(
                  'Processing...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
