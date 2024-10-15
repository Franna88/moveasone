import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationAddGrid.dart';
import 'package:move_as_one/admin/adminItems/AddMotivation/MotivationView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/newVideosGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/uploadButton.dart';
import 'package:move_as_one/commonUi/headerWidget1.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/UserVideo/UserAddGridView.dart';
import 'package:move_as_one/userSide/UserVideo/UserVideoView.dart';

class MotivationAdd extends StatefulWidget {
  const MotivationAdd({super.key});

  @override
  State<MotivationAdd> createState() => _UserAddVideoState();
}

class _UserAddVideoState extends State<MotivationAdd> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget1(
          header: 'Add Motivation',
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutsFullLenght()),
            );
          },
        ),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MotivationView()),
                      );
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
                    height: 0.5,
                    width: MyUtility(context).width / 2.1,
                    decoration: BoxDecoration(color: Colors.grey),
                  )
                ],
              ),
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
                      'New Videos',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: MyUtility(context).width / 2.1,
                    decoration: BoxDecoration(color: Color(0xFF006261)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Motivationaddgrid(),
        UploadButton(
          buttonColor: UiColors().brown,
          buttonText: 'Upload to App',
          onTap: () {
            Useraddgridview.of(context)?.uploadImage();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WorkoutsFullLenght()), // Replace DesiredPage with the page you want to navigate to
            );
          },
        ),
      ],
    );
  }
}
