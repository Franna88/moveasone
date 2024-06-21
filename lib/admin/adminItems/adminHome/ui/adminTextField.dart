import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  final String hintText;
  const AdminTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 0.2,
          )),
      child: TextField(
        minLines: 1,
        maxLines: 5,
        
        
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
