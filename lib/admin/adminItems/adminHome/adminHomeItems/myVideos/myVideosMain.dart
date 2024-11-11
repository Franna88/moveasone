import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/myVideoList/ui/myVideosGridView.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/newVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/workoutsFullLenght.dart';
import 'package:move_as_one/commonUi/headerWidget1.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/myutility.dart';

class MyVideosMain extends StatelessWidget {
  const MyVideosMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      children: [
        HeaderWidget1(
          showBackIcon: true,
          header: 'NEW SHORT',
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
                    decoration: BoxDecoration(color: Color(0xFF006261)),
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewVideosMain()),
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
        MyVideoGridView(),
      ],
    );
  }
}
