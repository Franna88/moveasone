import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/adminTextField.dart';
import 'package:move_as_one/admin/adminItems/adminHome/ui/columnHeader.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/admin/commonUi/adminColors.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class WriteAMessage extends StatelessWidget {
  const WriteAMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'WRITE A MESSAGE'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColumnHeader(header: 'New Photo'),
                  CommonButtons(
                      buttonText: 'Upload Photo',
                      onTap: () {
                        //ADD LOGIC
                      },
                      buttonColor: AdminColors().lightBrown),
                  ColumnHeader(header: 'Header Title'),
                  AdminTextField(hintText: 'Title here'),
                  ColumnHeader(header: 'Sub Title'),
                  AdminTextField(hintText: 'Sub Title here'),
                  const SizedBox(height: 20,),
                  CommonButtons(
                      buttonText: 'Save',
                      onTap: (){},
                      buttonColor: UiColors().teal)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
