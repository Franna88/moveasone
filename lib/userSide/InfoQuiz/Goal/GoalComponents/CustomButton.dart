import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:move_as_one/myutility.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Function(bool) onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: MyUtility(context).width / 1.2,
        height: MyUtility(context).height * 0.08,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onPressed(!widget.isSelected);
                },
                splashColor: widget.isSelected
                    ? Color(0xFF006261).withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                highlightColor: widget.isSelected
                    ? Color(0xFF006261).withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Color(0xFF006261).withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isSelected
                            ? Color(0xFF006261).withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            color:
                                widget.isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                        if (widget.isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 24,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
