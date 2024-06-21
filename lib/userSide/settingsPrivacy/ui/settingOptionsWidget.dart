import 'package:flutter/material.dart';

class SettingOptionsWidget extends StatelessWidget {
  final String settingText;
  final Widget settingWidget;
  const SettingOptionsWidget(
      {super.key, required this.settingText, required this.settingWidget});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
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
                Text(
                  settingText,
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                settingWidget
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
    );
  }
}
