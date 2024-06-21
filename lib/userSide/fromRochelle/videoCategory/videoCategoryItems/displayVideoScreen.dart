import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/comment&LikeWidget.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/ui/videoDetails.dart';
import 'package:move_as_one/userSide/fromRochelle/videoCategory/videoCategoryItems/commentsItems/comments.dart';

class DisplayVideoScreen extends StatefulWidget {
  DisplayVideoScreen({
    super.key,
  });

  @override
  State<DisplayVideoScreen> createState() => _DisplayVideoScreenState();
}

class _DisplayVideoScreenState extends State<DisplayVideoScreen> {
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
    return Container(
      height: heightDevice * 0.79,
      width: widthDevice,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/video10.png'),
          fit: BoxFit.cover,
        ),
      ),
      child:
          //Comments(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CommentLikeWidget(count: '1k', icon: Icons.favorite_border),
              GestureDetector(
                onTap: () {
                  changePageIndex(1);
                },
                child: CommentLikeWidget(
                    count: '12,3k', icon: Icons.chat_bubble_outline),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: VideoDetails(
                    videoDescription: 'Short description of workout here',
                    videoTitle: 'Upper Body Workout'),
              ),
              Visibility(
                visible: pageIndex == 1 ? true : false,
                child: Comments(changePageIndex: changePageIndex),
              )
            ],
          ),
    );
  }
}
