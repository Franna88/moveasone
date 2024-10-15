import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class LastWorkoutImages extends StatefulWidget {
  final String image;
  final String dateandworkout;

  const LastWorkoutImages({
    super.key,
    required this.image,
    required this.dateandworkout,
  });

  @override
  State<LastWorkoutImages> createState() => _LastWorkoutImagesState();
}

class _LastWorkoutImagesState extends State<LastWorkoutImages> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: MyUtility(context).height * 0.17,
            width: MyUtility(context).width / 2.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: widget.image.isNotEmpty
                    ? NetworkImage(widget.image)
                    : AssetImage('assets/placeholder.png') as ImageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: MyUtility(context).width * 0.35,
            child: Text(
              widget.dateandworkout,
              style: TextStyle(
                color: Color(0xFF006261),
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          )
        ],
      ),
    );
  }
}
