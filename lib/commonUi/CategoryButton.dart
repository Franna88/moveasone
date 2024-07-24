import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class CategoryButton extends StatefulWidget {
  final bool status;
  final Function(bool) onToggle;
  const CategoryButton(
      {super.key, required this.status, required this.onToggle});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
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
      value: widget.status,
      onToggle: widget.onToggle,
    );
  }
}
