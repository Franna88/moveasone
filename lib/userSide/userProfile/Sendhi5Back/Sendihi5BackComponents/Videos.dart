import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/UserProfile/Sendhi5Back/Sendihi5BackComponents/VideoImages.dart';
import 'package:move_as_one/myutility.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Videos',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 20,
                  fontFamily: 'Belight',
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFF0085FF), // Text color
                    fontSize: 15,
                    fontFamily: 'BeVietnam',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: MyUtility(context).width * 0.02,
              ),
              VideoImages(image: 'images/videos1.jpg'),
              VideoImages(image: 'images/videos2.jpg'),
              VideoImages(image: 'images/videos3.jpg'),
            ],
          ),
        ),
      ],
    );
  }
}
