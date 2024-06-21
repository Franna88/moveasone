import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/myVideoList.dart';

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
        child: GridView.builder(
          itemCount: myVideos.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: heightDevice * 0.10,
                width: widthDevice * 0.10,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(myVideos[index]),
                      fit: BoxFit.cover),
                ),
              ),
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
