import 'package:flutter/material.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/myDivider.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class BottomButtonContainer extends StatelessWidget {
  Function() onPressed;
  final String buttonText;
  BottomButtonContainer({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: 90,
      width: widthDevice,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyDivider(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CommonButtons(
                buttonText: buttonText,
                onTap: onPressed,
                buttonColor: UiColors().primaryBlue),
          ),
        ],
      ),
    );
  }
}
