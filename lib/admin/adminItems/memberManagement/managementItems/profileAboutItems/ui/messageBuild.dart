import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class MessageBuild extends StatelessWidget {
  final String messangerName;
  final String message;
  final String timeStamp;
  const MessageBuild({super.key, required this.messangerName, required this.message, required this.timeStamp});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: widthDevice * 0.85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 241, 235, 243)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 15,
                    backgroundImage: AssetImage('images/Avatar1.jpg'),
                  ),
                  const SizedBox(width: 8,),
                  Text(messangerName , style: TextStyle(fontFamily: 'Inter-Medium' , fontSize: 15 , fontWeight: FontWeight.w600),),
                  Spacer(),
                  Text(timeStamp, style: TextStyle(fontFamily: 'Inter-Medium' , fontSize: 12, color: UiColors().textgrey),),
                ],
              ),
              SizedBox(height: 15,),
              Text(message, style: TextStyle(fontFamily: 'Inter-Medium' , fontSize: 13, height: 1.2),),
            ],
          ),
        ),
      ),
    );
  }
}
