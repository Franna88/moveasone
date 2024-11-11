import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
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
    var widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          HeaderWidget(header: 'Workouts'),
          VideoCategory(),
          /*Container(
            height: 15,
            width: widthDevice,
            color: Colors.white,
          ),*/
          Expanded(
            // Make the content flexible
            child: Visibility(
              visible: pageIndex == 0,
              child: VideoGridView(changePageIndex: changePageIndex),
            ),
          ),
          Expanded(
            child: Visibility(
              visible: pageIndex == 1,
              child: DisplayVideoScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
