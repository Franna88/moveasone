import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(children: [HeaderWidget(header: 'PRIVACY POLICY')]);
  }
}