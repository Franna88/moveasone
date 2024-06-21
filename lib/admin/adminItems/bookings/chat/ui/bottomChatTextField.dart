import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class BottomChatTextField extends StatelessWidget {
  const BottomChatTextField({super.key});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(
          Icons.add,
          size: 30,
        ),
        Container(
          width: widthDevice * 0.86,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Container(
                width: widthDevice * 0.76,
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    hintText: 'Type your message...',
                    
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: ShapeDecoration(
                  color: UiColors().teal,
                  shape: CircleBorder(),
                ),
              ),
              const SizedBox(width: 10,)
            ],
          ),
        ),
      ],
    );
  }
}
