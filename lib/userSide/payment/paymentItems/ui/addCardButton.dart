import 'package:flutter/material.dart';

class AddCardButton extends StatelessWidget {
  Function() onTap;
  AddCardButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        onTap;
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          height: heightDevice * 0.13,
          width: widthDevice * 0.15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 246, 231, 248)),
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
