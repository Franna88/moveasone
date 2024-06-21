import 'package:flutter/material.dart';
import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/headerWidget.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';

class WriteAReview extends StatelessWidget {
  const WriteAReview({super.key});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    var heightDevice = MediaQuery.of(context).size.height;
    return MainContainer(
      children: [
        SizedBox(
          height: heightDevice,
          child: Column(
            children: [
              HeaderWidget(header: 'WRITE A MESSAGE'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: widthDevice * 0.90,
                  height: heightDevice * 0.18,
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
                      onChanged: (value) => {},
                      cursorColor: Colors.black,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Message here',
                        hintStyle: TextStyle(fontWeight: FontWeight.w400),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 30),
                child: CommonButtons(
                    buttonText: 'Send',
                    onTap: () {
                      //ADD LOGIC HERE
                    },
                    buttonColor: Colors.black),
              )
            ],
          ),
        )
      ],
    );
  }
}
