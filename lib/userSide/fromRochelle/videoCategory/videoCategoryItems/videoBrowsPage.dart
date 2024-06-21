import 'package:flutter/material.dart';
import 'package:move_as_one/BottomNavBar/BottomNavBar.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/videoCategory.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/videoGridView.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/displayVideoScreen.dart';

class VideoBrowsPage extends StatefulWidget {
  const VideoBrowsPage({super.key});

  @override
  State<VideoBrowsPage> createState() => _VideoBrowsPageState();
}

class _VideoBrowsPageState extends State<VideoBrowsPage> {
  var pageIndex = 0;

  changePageIndex(value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        VideoCategory(),
        Container(
          height: 15,
          width: widthDevice,
          color: Colors.white,
        ),
        Visibility(
            visible: pageIndex == 0 ? true : false,

            child: VideoGridView(changePageIndex: changePageIndex)),
        Visibility(
            visible: pageIndex == 1 ? true : false,
            
            child: DisplayVideoScreen()),
      ],
    );
  }
}
