import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class DropDownContent extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  const DropDownContent({
    super.key,
    required this.widget1,
    required this.widget2,
  });

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Column(
      children: [widget1, widget2,],
    );
  }
}
