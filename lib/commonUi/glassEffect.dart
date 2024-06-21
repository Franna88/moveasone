import 'dart:ui';

import 'package:flutter/material.dart';

class GlassEffect extends StatefulWidget {
  Widget child;
  GlassEffect({super.key, required this.child});

  @override
  State<GlassEffect> createState() => _GlassEffectState();
}

class _GlassEffectState extends State<GlassEffect> {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        new ClipRect(
          child: new Container(
            width: 190,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey.shade200.withOpacity(0.4)),
            child: new Center(child: widget.child),
          ),
        ),
      ],
    );
  }
}
