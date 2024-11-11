import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String header;
  final bool
      showBackButton; // New property to control visibility of GestureDetector

  const HeaderWidget(
      {super.key,
      required this.header,
      this.showBackButton = true}); // Default value is true

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;

    return Container(
      width: widthDevice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: Row(
              mainAxisAlignment: showBackButton
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center, // Align based on visibility
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (showBackButton) ...[
                  const SizedBox(width: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ],
                Container(
                  width: showBackButton
                      ? widthDevice * 0.80
                      : widthDevice * 0.90, // Adjust width
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      header,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.2,
            width: widthDevice,
            color: Color.fromARGB(255, 128, 126, 126),
          ),
        ],
      ),
    );
  }
}
