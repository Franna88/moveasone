import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/mySwitchButton.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/customSwitch.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/settingOptionsWidget.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;

    return MainContainer(
      children: [
        HeaderWidget(header: 'NOTIFICATIONS'),
        SettingOptionsWidget(
          settingText: 'Workout reminders',
          settingWidget: MySwitchButton(),
        ),
        SettingOptionsWidget(
          settingText: 'Weekly fitness report',
          settingWidget: MySwitchButton(),
        ),
        SizedBox(
          height: heightDevice * 0.04,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Social',
              style: TextStyle(fontSize: 18, fontFamily: 'BeVietnam',),
            ),
          ),
        ),
        SizedBox(
          height: heightDevice * 0.04,
        ),
        SettingOptionsWidget(
          settingText: 'New follower',
          settingWidget: MySwitchButton(),
        ),
        SettingOptionsWidget(
          settingText: 'Follow request accepted',
          settingWidget: MySwitchButton(),
        ),
        SettingOptionsWidget(
          settingText: 'Follow suggestions',
          settingWidget: MySwitchButton(),
        ),
        SettingOptionsWidget(
          settingText: 'Comments',
          settingWidget: MySwitchButton(),
        ),
        SettingOptionsWidget(
          settingText: 'Message',
          settingWidget: MySwitchButton(),
        ),
      ],
    );
  }
}
