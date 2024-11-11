import 'package:flutter/material.dart';

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
