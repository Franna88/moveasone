import 'package:flutter/material.dart';

class WatchButton extends StatefulWidget {
  WatchButton({
    super.key,
  });

  @override
  State<WatchButton> createState() => _WatchButtonState();
}

class _WatchButtonState extends State<WatchButton> {
  bool watched = false;

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          watched = !watched;
        });
      },
      child: Container(
        width: widthDevice * 0.25,
        decoration: ShapeDecoration(
          color: watched ? Color(0xFF006261) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFF006261),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: watched
                ? Text(
                    'Watch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  )
                : Text(
                    'Not Watched',
                    style: TextStyle(
                      color: Color(0xFF006261),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
