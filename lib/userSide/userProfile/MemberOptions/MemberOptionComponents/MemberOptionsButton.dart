import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class MemberOptionsButton extends StatefulWidget {
  final String images;
  final String memberoptions;
  final VoidCallback onPressed;

  const MemberOptionsButton(
      {super.key,
      required this.images,
      required this.memberoptions,
      required this.onPressed});

  @override
  State<MemberOptionsButton> createState() => _MemberOptionsButtonState();
}

class _MemberOptionsButtonState extends State<MemberOptionsButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: MyUtility(context).width / 1.15,
            height: MyUtility(context).height * 0.12,
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(widget.images),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.memberoptions,
                        style: TextStyle(
                          color: Color(0xFF006261),
                          fontSize: 22,
                          fontFamily: 'BeVietnam',
                          fontWeight: FontWeight.w300,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
