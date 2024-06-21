import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/newVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/MembersColumn.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/columnHeader.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/messagesColumn.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/workoutsColumn.dart';
import 'package:move_as_one/commonUi/AdminRachelle.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';

class WorkoutsFullLenght extends StatelessWidget {
  const WorkoutsFullLenght({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: heightDevice,
          width: widthDevice,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MyUtility(context).width,
                    height: MyUtility(context).height / 1.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/bicepFlex.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MyUtility(context).height * 0.21,
                        ),
                        SizedBox(
                          width: MyUtility(context).width / 1.15,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'You ',
                                    style: TextStyle(
                                      color: Color(0xFF006261),
                                      fontSize: 44,
                                      fontFamily: 'belight',
                                      height: 0.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'can',
                                    style: TextStyle(
                                      color: Color(0xFFAA5F3A),
                                      fontSize: 44,
                                      fontFamily: 'belight',
                                      height: 0.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' be \nGreat',
                                    style: TextStyle(
                                      color: Color(0xFF006261),
                                      fontSize: 44,
                                      fontFamily: 'belight',
                                      height: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: SizedBox(
                            width: MyUtility(context).width / 1.15,
                            child: Text(
                              'You have the power to decide to be great. Lets start now! ',
                              style: TextStyle(
                                color: Color(0xA5006261),
                                fontSize: 16,
                                fontFamily: 'Be Vietnam',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MyUtility(context).width / 1.15,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MyUtility(context).width * 0.5,
                              height: MyUtility(context).height * 0.05,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: ShapeDecoration(
                                color: Color(0xFF006261),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Update App Header',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'belight',
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  AdminRachelle(),
                  //ADD NEW SHORT BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewVideosMain()),
                      ),
                      child: SizedBox(
                        width: MyUtility(context).width / 1.15,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: MyUtility(context).width * 0.5,
                            height: MyUtility(context).height * 0.05,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: ShapeDecoration(
                              color: Color(0xFF006261),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Add New Short',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'belight',
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  WorkoutsColumn(),
                  MembersColumn(),
                  MessagesColumn(),
                  SizedBox(
                    height: heightDevice * 0.05,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
