import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class Newswitchbutton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;

  const Newswitchbutton(
      {super.key, required this.initialValue, required this.onToggle});

  @override
  State<Newswitchbutton> createState() => _NewswitchbuttonState();
}

class _NewswitchbuttonState extends State<Newswitchbutton> {
  late bool status;

  @override
  void initState() {
    super.initState();
    status = widget.initialValue;
  }

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
      value: widget.initialValue,
      onToggle: (val) {
        setState(() {
          status = val;
        });
        widget.onToggle(val);
      },
    );
  }
}
