import 'package:flutter/material.dart';

import 'package:move_as_one/admin/adminItems/workoutCreator/creatorFullView/warmUpCreator.dart';
import 'package:move_as_one/admin/adminItems/workoutCreator/creatorVideoOverlays/overlayItems/resultsScreenTwo.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class ExerciseVideoWidget extends StatefulWidget {
  final String docId;
  final String imageUrl;
  final String header;
  final String info;
  final Map<String, dynamic> warmupData;
  final List list;
  final String userType;
  final String type;

  const ExerciseVideoWidget(
      {super.key,
      required this.docId,
      required this.imageUrl,
      required this.header,
      required this.info,
      required this.userType,
      required this.list,
      required this.warmupData,
      required this.type});

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.userType == "user"
                ? ResultsScreenTwo(
                    videoUrl:
                        widget.warmupData['videoUrl'], // Pass video URL here
                  )
                : WarmUpCreator(
                    docId: widget.docId,
                    type: widget.type, // Replace with the actual type if needed
                    warmupData: widget.warmupData,
                    exerciseList: widget.list,
                  ),
          ),
        );
        /* */
      },
      child: Container(
        //  height: heightDevice * 0.15,
        color: isActive ? UiColors().teal : Colors.white,
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
                    image: widget.imageUrl != ""
                        ? NetworkImage(widget.imageUrl)
                        : AssetImage('images/placeholder.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(
                      width: widthDevice * 0.54,
                      child: Text(
                        widget.info,
                        style: TextStyle(
                          fontFamily: 'BeVietnam',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              /**/
            ],
          ),
        ),
      ),
    );
  }
}
