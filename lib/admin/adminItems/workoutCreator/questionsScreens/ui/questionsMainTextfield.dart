import 'package:flutter/material.dart';

class QuestionsMainTextfield extends StatelessWidget {
  Function() onChanged;
  final String hintText;

  QuestionsMainTextfield({
    super.key,
    required this.onChanged, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    var heightDevice = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: widthDevice * 0.90,
          height: heightDevice * 0.12,
          decoration: BoxDecoration(
            border: Border.all(width: 0.1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 187, 187, 187),
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) => onChanged,
              cursorColor: Colors.black,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontWeight: FontWeight.w400),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                border: InputBorder.none,
                
              ),
            ),
          ),
        ));
  }
}
