import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/WorkoutCreatorVIdeo/FullScreenVideoPlayer.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/DeleteButtonPopup.dart';

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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: SizedBox(
            height: heightDevice * 0.72,
            child: FutureBuilder<QuerySnapshot>(
              future: _videoFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var videos = snapshot.data!.docs;

                return GridView.builder(
                  itemCount: videos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    var video = videos[index];
                    var videoId = video.id;
                    var thumbnailUrl = video['thumbnailUrl'];
                    var imageUrl =
                        video['imageUrl'] ?? ''; // Optional cover image
                    var videoName = video['videoName'];
                    var videoUrl = video['videoUrl'];

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
                      onLongPress: () {
                        showDeleteDialog(context, videoId, _refreshVideos);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          children: [
                            Container(
                              height: heightDevice * 0.12,
                              width: widthDevice * 0.25,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(imageUrl.isNotEmpty
                                        ? imageUrl
                                        : thumbnailUrl),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Text(
                              videoName,
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          builder: (context, child) => Padding(
            padding:
                EdgeInsets.only(top: 100 - _animationController.value * 100),
            child: child,
          ),
        ),
        if (isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(value: progress),
                SizedBox(height: 20),
                Text(
                  'Uploading... ${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 16),
                ),
                if (imageUploadProgress > 0.0 && imageUploadProgress < 1.0)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(value: imageUploadProgress),
                        SizedBox(height: 10),
                        Text(
                          'Uploading Image... ${(imageUploadProgress * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
