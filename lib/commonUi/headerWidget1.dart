import 'package:flutter/material.dart';

class HeaderWidget1 extends StatefulWidget {
  final String header;
  final VoidCallback onPress;
  final bool showBackIcon;

  const HeaderWidget1({
    Key? key,
    required this.header,
    required this.onPress,
    this.showBackIcon = false,
  }) : super(key: key);

  @override
  State<HeaderWidget1> createState() => _HeaderWidget1State();
}

class _HeaderWidget1State extends State<HeaderWidget1> {
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
            padding: const EdgeInsets.only(top: 25, bottom: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back Icon Positioned on the Left
                if (widget.showBackIcon)
                  Positioned(
                    left: 15,
                    child: GestureDetector(
                      onTap: widget.onPress,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                // Centered Header Text
                Center(
                  child: Text(
                    widget.header,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
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
