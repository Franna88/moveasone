import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_as_one/WorkoutCreatorVIdeo/FullScreenVideoPlayer.dart';

class Userviewgridview extends StatefulWidget {
  const Userviewgridview({super.key});

  @override
  State<Userviewgridview> createState() => _UserviewgridviewState();
}

class _UserviewgridviewState extends State<Userviewgridview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future<DocumentSnapshot> _videoFuture;
  bool _isLoading = true;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF6699CC);
  final Color secondaryColor = const Color(0xFF7FB2DE);
  final Color accentColor = const Color(0xFFA3E1DB);
  final Color subtleColor = const Color(0xFFE5F9E0);
  final Color backgroundColor = const Color(0xFFF8FFFA);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
    _refreshVideos();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshVideos() {
    setState(() {
      _isLoading = true;
    });

    final uid = FirebaseAuth.instance.currentUser!.uid;
    _videoFuture =
        FirebaseFirestore.instance.collection('users').doc(uid).get();

    _videoFuture.then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background subtle pattern
        Container(
          color: backgroundColor,
        ),

        // Main content
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _animationController.value)),
              child: Opacity(
                opacity: _animationController.value,
                child: child,
              ),
            );
          },
          child: Container(
            height: heightDevice * 0.72,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Videos',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: secondaryColor),
                        onPressed: _refreshVideos,
                      ),
                    ],
                  ),
                ),

                // Video grid
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(secondaryColor),
                          ),
                        )
                      : FutureBuilder<DocumentSnapshot>(
                          future: _videoFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      secondaryColor),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[300],
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text('Error loading videos'),
                                  ],
                                ),
                              );
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Center(child: Text('No videos found'));
                            }

                            var userVideos = snapshot.data!.get('userVideos')
                                as List<dynamic>;

                            if (userVideos.isEmpty) {
                              return _buildEmptyState();
                            }

                            return RefreshIndicator(
                              color: secondaryColor,
                              onRefresh: () async {
                                _refreshVideos();
                              },
                              child: GridView.builder(
                                itemCount: userVideos.length,
                                physics: AlwaysScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.8,
                                ),
                                itemBuilder: (context, index) {
                                  var video = userVideos[index];

                                  // Add null safety with default values
                                  var thumbnailUrl =
                                      video['thumbnailUrl'] as String? ?? '';
                                  var videoName =
                                      video['videoName'] as String? ??
                                          'Untitled Video';
                                  var videoUrl =
                                      video['videoUrl'] as String? ?? '';

                                  // Skip videos with empty URLs to prevent playback errors
                                  if (videoUrl.isEmpty) {
                                    return Container(); // Return empty container for invalid videos
                                  }

                                  final delay = 0.2 + (index * 0.1);
                                  final delayedAnimation = CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval(delay.clamp(0.0, 1.0), 1.0,
                                        curve: Curves.easeOut),
                                  );

                                  return AnimatedBuilder(
                                    animation: delayedAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                            20 * (1 - delayedAnimation.value),
                                            0),
                                        child: Opacity(
                                          opacity: delayedAnimation.value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _buildVideoCard(thumbnailUrl,
                                        videoName, videoUrl, index),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
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
          Icon(
            Icons.videocam_off_outlined,
            size: 64,
            color: primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 24),
          Text(
            'No videos yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Your uploaded videos will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
      String thumbnailUrl, String videoName, String videoUrl, int index) {
    return Card(
      elevation: 3,
      shadowColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: subtleColor,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenVideoPlayer(
                videoUrl: videoUrl,
                videoName: videoName,
                thumbnailUrl: thumbnailUrl,
              ),
            ),
          );
        },
        onLongPress: () {
          showDeleteDialog(context, index, _refreshVideos);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button overlay
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: thumbnailUrl.isNotEmpty
                        ? Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: 48,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.videocam_outlined,
                              color: primaryColor.withOpacity(0.5),
                              size: 48,
                            ),
                          ),
                  ),

                  // Play button overlay
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  // Gradient overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Video title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Tap to play',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showDeleteDialog(
    BuildContext context, int index, VoidCallback refreshVideos) {
  final primaryColor = Color(0xFF6699CC);
  final secondaryColor = Color(0xFF7FB2DE);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red[400]),
            SizedBox(width: 8),
            Text(
              'Delete Video',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this video? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              DocumentReference userDoc =
                  FirebaseFirestore.instance.collection('users').doc(uid);
              DocumentSnapshot userSnapshot = await userDoc.get();
              List<dynamic> userVideos = userSnapshot.get('userVideos');

              userVideos.removeAt(index);

              await userDoc.update({'userVideos': userVideos});
              refreshVideos();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
