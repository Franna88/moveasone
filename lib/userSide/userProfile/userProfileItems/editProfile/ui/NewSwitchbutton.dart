import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class NewSwitchButton extends StatefulWidget {
  const NewSwitchButton({super.key});

  @override
  State<NewSwitchButton> createState() => _NewSwitchButtonState();
}

class _NewSwitchButtonState extends State<NewSwitchButton> {
  bool status = true;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      height: 25,
      width: 50,
      padding: 2,
      toggleSize: 22,
      borderRadius: 20,
      activeColor: UiColors().teal,
      inactiveColor: Colors.grey,
      value: status,
      onToggle: (val) {
        setState(
          () {
            status = val;
          },
        );
      },
    );
  }
}
