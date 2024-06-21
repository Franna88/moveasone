import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String header;
  const ProfileHeader({super.key, required this.header});

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
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 30,
            ),
          ),
          Container(
            width: widthDevice * 0.80,
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                header,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
