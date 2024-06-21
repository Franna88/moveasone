import 'package:flutter/material.dart';
import 'dart:ui';

class BottomVideoBlurCon extends StatefulWidget {
  final List<Widget> children;
  const BottomVideoBlurCon({super.key, required this.children});

  @override
  State<BottomVideoBlurCon> createState() => _BottomVideoBlurConState();
}

class _BottomVideoBlurConState extends State<BottomVideoBlurCon> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        new ClipRect(
          child: BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: new Container(
              width: widthDevice,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey.shade200.withOpacity(0.3),
              ),
              child: new Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 4,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.children
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
