import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/WorkoutCreatorVideo/FullScreenVideoPlayer.dart';
import 'package:move_as_one/myutility.dart';

class Rachelle extends StatefulWidget {
  final bool showHeader;
  const Rachelle({super.key, this.showHeader = true});

  @override
  State<Rachelle> createState() => _RachelleState();
}

class _RachelleState extends State<Rachelle>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = -1;
  List<Map<String, String>> videos = [];
  late PageController _pageController;
  late AnimationController _animationController;

  // Modern color scheme - coordinated with main app colors
  final Color primaryColor = const Color(0xFF025959);
  final Color secondaryColor = const Color(0xFF01B3B3);
  final Color accentColor = const Color(0xFF94FBAB);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.55, // Show partial next/previous items
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fetchVideos();
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
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
      height: MyUtility(context).height * 0.32,
      child: Column(
        children: [
          if (widget.showHeader) ...[
            // Modern header with subtle animation (re-add if needed)
            // You can copy the header code here if you want to show it
          ],
          // Modern video carousel with depth effect
          Expanded(
            child: videos.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: videos.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final bool isActive = _selectedIndex == index;
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                0, 30 * (1 - _animationController.value)),
                            child: Opacity(
                              opacity: _animationController.value,
                              child: AnimatedScale(
                                scale: isActive ? 1.0 : 0.85,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: _buildVideoCard(
                          videos[index]['thumbnailUrl'] ?? '',
                          videos[index]['description'] ?? '',
                          videos[index]['videoUrl'] ?? '',
                          isActive,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
      String thumbnailUrl, String description, String videoUrl, bool isActive) {
    return GestureDetector(
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(isActive ? 0.2 : 0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Thumbnail with gradient overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
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

            // Play button overlay
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
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

            // Video title
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.swipe_up,
                        color: Colors.white.withOpacity(0.7),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Swipe to watch',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
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
