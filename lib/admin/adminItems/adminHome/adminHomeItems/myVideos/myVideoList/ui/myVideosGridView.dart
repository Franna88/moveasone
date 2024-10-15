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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Edit Video'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Video Name'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Text('Save')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDeleteDialog(context, videoId, _refreshVideos);
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Text('Delete')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
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
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                var video = videos[index];
                var videoId = video.id;
                var thumbnailUrl = video['thumbnailUrl'];
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
                    _showEditDialog(videoId, videoName);
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
                                image: NetworkImage(thumbnailUrl),
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
        padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
        child: child,
      ),
    );
  }
}
