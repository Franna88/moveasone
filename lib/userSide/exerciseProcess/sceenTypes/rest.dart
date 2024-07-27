import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../../../commonUi/navVideoButton.dart';
import '../../../commonUi/uiColors.dart';

class Rest extends StatefulWidget {
  String imageUrl;
  Function changePageIndex;
  Rest({super.key, required this.imageUrl, required this.changePageIndex});

  @override
  State<Rest> createState() => _RestState();
}

class _RestState extends State<Rest> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice,
      width: widthDevice,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              widget.imageUrl,
            ),
            fit: BoxFit.fitHeight),
      ),
      child: Column(
        children: [
          SizedBox(
            height: heightDevice * 0.05,
          ),
          NavVideoButton(
            buttonColor: UiColors().teal,
            buttonText: 'Next Workout',
            onTap: () {
              widget.changePageIndex();
            },
          ),
        ],
      ),
    );
  }
}
