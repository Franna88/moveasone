import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/newVideosGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/uploadButton.dart';
import 'package:move_as_one/commonUi/headerWidget1.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/myutility.dart';

class NewVideosMain extends StatefulWidget {
  const NewVideosMain({super.key});

  @override
  State<NewVideosMain> createState() => _NewVideosMainState();
}

class _NewVideosMainState extends State<NewVideosMain> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget1(
          header: 'NEW SHORT',
          showBackIcon: true,
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
                        MaterialPageRoute(builder: (context) => MyVideosMain()),
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
        NewVideosGridView(),
        UploadButton(
          buttonColor: UiColors().brown,
          buttonText: 'Upload to App',
          onTap: () {
            NewVideosGridView.of(context)?.uploadImage();
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
