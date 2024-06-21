import 'package:flutter/material.dart';

class CommentTextField extends StatelessWidget {
  final String hintText;
  const CommentTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice * 0.70,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.3, color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Expanded(
        child: TextField(
          
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          
          cursorColor: Colors.black,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 173, 172, 172),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
