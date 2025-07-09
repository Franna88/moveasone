import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/UserVideo/UserViewGridView.dart';

class Uservideoview extends StatefulWidget {
  final VoidCallback onNavigateToNewVideos;

  const Uservideoview({super.key, required this.onNavigateToNewVideos});

  @override
  State<Uservideoview> createState() => _UservideoviewState();
}

class _UservideoviewState extends State<Uservideoview> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      print('Other button tapped!');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF1E1E1E),
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Belight',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    child: Text(
                      'My Videos',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: MyUtility(context).width / 2.1,
                    decoration: BoxDecoration(color: Color(0xFF6699CC)),
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed:
                        widget.onNavigateToNewVideos, // Navigate to New Videos
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF1E1E1E),
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Belight',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    child: Text(
                      'New Videos',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: MyUtility(context).width / 2.1,
                    decoration: BoxDecoration(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Userviewgridview(),
      ],
    );
  }
}
