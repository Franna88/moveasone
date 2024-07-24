import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class DropDownContent extends StatelessWidget {
  final List<Widget> widgets;
  const DropDownContent({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widgets,
    );
  }
}
