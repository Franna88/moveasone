import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/userSide/Home/Motivational/SimpleVideoPlayer.dart';

class Motivational extends StatefulWidget {
  const Motivational({super.key});

  @override
  State<Motivational> createState() => _MotivationalState();
}

class _MotivationalState extends State<Motivational>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;

  // Modern wellness color scheme
  final Color primaryColor = const Color(0xFF6699CC); // Primary blue
  final Color secondaryColor = const Color(0xFF03A696); // Lighter teal
  final Color accentColor = const Color(0xFFF2E7D5); // Warm cream
  final Color backgroundColor = const Color(0xFFF7F9F9); // Off-white
  final Color textColor = const Color(0xFF2D3436); // Dark gray for text

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();

    // Simulate loading state
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.4,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                // Left side - Title with indicator
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 24,
                        width: 4,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Mindful Moments',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side - All Insights button
                GestureDetector(
                  onTap: () {
                    // Add navigation to full insights page
                    print('All Insights tapped');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'All Insights',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    ),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('motivation')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(secondaryColor),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        print(
                            'Error loading motivation videos: ${snapshot.error}');
                        return _buildErrorState();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        print('No motivation videos found');
                        return _buildEmptyState();
                      }

                      var motivationalVideos = snapshot.data!.docs;
                      print(
                          'Found ${motivationalVideos.length} motivation videos');

                      // Debug: Print all video data
                      print('=== MOTIVATION COLLECTION DEBUG ===');
                      for (int i = 0; i < motivationalVideos.length; i++) {
                        var videoData = motivationalVideos[i].data()
                            as Map<String, dynamic>;
                        print('Video $i:');
                        print('  Document ID: ${motivationalVideos[i].id}');
                        print('  All fields: $videoData');
                        print('  videoUrl field: ${videoData['videoUrl']}');
                        print('  url field: ${videoData['url']}');
                        print('  videoName field: ${videoData['videoName']}');
                        print('  title field: ${videoData['title']}');
                        print('  imageUrl field: ${videoData['imageUrl']}');
                        print(
                            '  thumbnailUrl field: ${videoData['thumbnailUrl']}');
                        print('  ---');
                      }
                      print('=== END DEBUG ===');

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: motivationalVideos.length,
                        itemBuilder: (context, index) {
                          var data = motivationalVideos[index].data()
                              as Map<String, dynamic>;

                          // Debug: Print all data for this video
                          print('Motivation video $index data: $data');
                          print('Available keys: ${data.keys.toList()}');

                          return _buildMotivationalCard(
                            data['imageUrl'] ?? data['thumbnailUrl'] ?? '',
                            data['videoName'] ?? data['title'] ?? '',
                            data['videoUrl'] ?? data['url'] ?? '',
                            index,
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Unable to load content',
            style: TextStyle(
              color: Colors.red[300],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa_outlined,
            size: 48,
            color: primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'Your mindful journey awaits',
            style: TextStyle(
              fontSize: 16,
              color: primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard(
      String imageUrl, String title, String videoUrl, int index) {
    return GestureDetector(
      onTap: () {
        print('=== VIDEO TAP DEBUG ===');
        print('Card index: $index');
        print('Video URL: $videoUrl');
        print('Video title: $title');
        print('Image URL: $imageUrl');
        print('URL length: ${videoUrl.length}');
        print('URL is empty: ${videoUrl.isEmpty}');
        print('========================');

        if (videoUrl.isNotEmpty &&
            videoUrl != 'null' &&
            videoUrl.startsWith('http')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleVideoPlayer(
                videoUrl: videoUrl,
                videoName: title,
                thumbnailUrl: imageUrl,
              ),
            ),
          );
        } else {
          print('ERROR: Video URL is empty or invalid, cannot play video');
          // Show user-friendly error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Video not available. Please try again later.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const AssetImage('images/default_thumbnail.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.self_improvement,
                      color: UiColors().primaryBlue,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Wellness',
                      style: TextStyle(
                        color: UiColors().primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isNotEmpty ? title : 'Untitled',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(
                        Icons.swipe_up,
                        color: Colors.white70,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Swipe to watch',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
