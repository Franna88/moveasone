import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/adminHomeItems/myVideos/newVideosMain.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/MembersColumn.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/UpdateHeader.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/messagesColumn.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/workoutsColumn.dart';
import 'package:move_as_one/commonUi/AdminRachelle.dart';
import 'package:move_as_one/myutility.dart';

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
                  UpdateHeader(),
                  AdminRachelle(),
                  //ADD NEW SHORT BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewVideosMain()),
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
                  // motivation button can also be found here
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
