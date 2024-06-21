import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class ExerciseVideoWidget extends StatefulWidget {
  final String assetName;
  final String header;
  final String info;
  const ExerciseVideoWidget({super.key, required this.assetName, required this.header, required this.info});

  @override
  State<ExerciseVideoWidget> createState() => _ExerciseVideoWidgetState();
}

class _ExerciseVideoWidgetState extends State<ExerciseVideoWidget> {

  bool isActive = false;
  
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
      },
      child: Container(
        height: heightDevice *0.15,
        color: isActive? UiColors().teal : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                height: heightDevice * 0.11,
                width: widthDevice * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(widget.assetName),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.header,
                      style: TextStyle(
                        fontFamily: 'BeVietnam',
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.info,
                      style: TextStyle(
                        fontFamily: 'BeVietnam',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}