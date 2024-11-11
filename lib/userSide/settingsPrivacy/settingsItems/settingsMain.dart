import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_as_one/Services/UserState.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/language.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/notifications.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/privacyPolicy.dart';
import 'package:move_as_one/userSide/settingsPrivacy/settingsItems/unitOfMeasure.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/arrowRightIcon.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/userSide/settingsPrivacy/ui/settingOptionsWidget.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderWidget(header: 'SETTINGS'),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UnitOfMeasure()),
                  );
                },
                child: SettingOptionsWidget(
                  settingText: 'Unit of Measure',
                  settingWidget: ArrowRightIcon(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()),
                  );
                },
                child: SettingOptionsWidget(
                  settingText: 'Notifications',
                  settingWidget: ArrowRightIcon(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()),
                  );
                },
                child: SettingOptionsWidget(
                  settingText: 'Privacy Policy',
                  settingWidget: ArrowRightIcon(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Language()),
                  );
                },
                child: SettingOptionsWidget(
                  settingText: 'Language',
                  settingWidget: ArrowRightIcon(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserState()),
                              );
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                  fontFamily: 'BeVietnam',
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          ArrowRightIcon()
                        ],
                      ),
                    ),
                    Container(
                      height: 0.2,
                      width: widthDevice,
                      color: Color.fromARGB(255, 128, 126, 126),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
