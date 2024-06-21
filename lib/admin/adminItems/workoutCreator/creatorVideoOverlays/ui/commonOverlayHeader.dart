import 'package:flutter/material.dart';

class CommonOverlayHeader extends StatelessWidget {
  final String header;
  final Color textColor;
  const CommonOverlayHeader(
      {super.key, required this.header, required this.textColor});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Container(
            width: widthDevice * 0.80,
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                header,
                style: TextStyle(
                  fontFamily: 'Inter',
                    fontSize: 16,
                    color: textColor,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
