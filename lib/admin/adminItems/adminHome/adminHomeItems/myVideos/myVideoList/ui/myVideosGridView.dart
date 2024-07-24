import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyVideoGridView extends StatefulWidget {
  const MyVideoGridView({super.key});

  @override
  State<MyVideoGridView> createState() => _MyVideoGridViewState();
}

class _MyVideoGridViewState extends State<MyVideoGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          future: FirebaseFirestore.instance.collection('shorts').get(),
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
                var thumbnailUrl = video['thumbnailUrl'];
                var videoName = video['videoName'];

                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Container(
                        height: heightDevice * 0.10,
                        width: widthDevice * 0.10,
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
