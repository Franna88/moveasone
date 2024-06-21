import 'package:flutter/material.dart';


List videoGridImages = [
  'images/videos1.jpg',
  'images/videos2.jpg',
  'images/videos3.jpg',
  'images/videos4.jpg',
  'images/videos5.jpg',
  'images/videos6.jpg',
  'images/videos7.jpg',
  'images/videos8.jpg',
  'images/videos1.jpg',
  'images/videos2.jpg',
  'images/videos3.jpg',
  'images/videos4.jpg',
  'images/videos5.jpg',
  'images/videos6.jpg',
  'images/videos7.jpg',
  'images/videos8.jpg',
];

class VideoGridView extends StatefulWidget {
  Function(int) changePageIndex;
  VideoGridView({super.key, required this.changePageIndex});

  @override
  State<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

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
      child: Container(
        color: Colors.white,
        height: heightDevice * 0.79,
        child: GridView.builder(
          itemCount: videoGridImages.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: GestureDetector(
                onTap: () {
                  widget.changePageIndex(1);
                },
                child: Container(
                  height: heightDevice * 0.10,
                  width: widthDevice * 0.10,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(videoGridImages[index]),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      builder: (context, child) => Padding(
        padding: EdgeInsets.only(top: 150 - _animationController.value * 150),
        child: child,
      ),
    );
  }
}
