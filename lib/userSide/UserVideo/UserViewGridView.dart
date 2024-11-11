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
    _refreshVideos();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshVideos() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      _videoFuture =
          FirebaseFirestore.instance.collection('users').doc(uid).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animationController,
      child: SizedBox(
        height: heightDevice * 0.72,
        child: FutureBuilder<DocumentSnapshot>(
          future: _videoFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var userVideos = snapshot.data!.get('userVideos') as List<dynamic>;

            return GridView.builder(
              itemCount: userVideos.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                var video = userVideos[index];
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
                    showDeleteDialog(context, index, _refreshVideos);
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

void showDeleteDialog(
    BuildContext context, int index, VoidCallback refreshVideos) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete Video'),
        content: Text('Are you sure you want to delete this video?'),
        actions: [
          TextButton(
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
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
        ],
      );
    },
  );
}
