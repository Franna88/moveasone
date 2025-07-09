import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/UserVideo/rebuilt_video_gallery.dart';

class UserAddVideo extends StatefulWidget {
  const UserAddVideo({super.key});

  @override
  State<UserAddVideo> createState() => _UserAddVideoState();
}

class _UserAddVideoState extends State<UserAddVideo> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        // Single header for Uploaded Videos
        Column(
          children: [
            Text(
              'Uploaded Videos',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Belight',
                fontWeight: FontWeight.w600,
                color: Color(0xFF6699CC),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 3,
              width: MyUtility(context).width * 0.6,
              decoration: BoxDecoration(
                color: Color(0xFF6699CC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height -
              200, // Fixed height instead of Expanded
          child: const RebuiltVideoGallery(),
        ),
      ],
    );
  }
}
