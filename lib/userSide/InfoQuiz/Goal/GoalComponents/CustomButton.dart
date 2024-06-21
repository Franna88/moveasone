import 'package:flutter/material.dart';

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
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              widget.onPressed(!widget.isSelected);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isSelected ? Color(0xFF006261) : Color(0xFFEBECEC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
