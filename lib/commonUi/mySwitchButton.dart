import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class MySwitchButton extends StatefulWidget {
  
  const MySwitchButton({super.key});

  @override
  State<MySwitchButton> createState() => _MySwitchButtonState();
}

class _MySwitchButtonState extends State<MySwitchButton> {
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
