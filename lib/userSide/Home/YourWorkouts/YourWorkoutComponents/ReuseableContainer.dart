import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class ReuseableContainer extends StatefulWidget {
  final String image;
  final String day;
  final String workout;

  const ReuseableContainer({
    super.key,
    required this.image,
    required this.day,
    required this.workout,
  });

  @override
  State<ReuseableContainer> createState() => _ReuseableContainerState();
}

class _ReuseableContainerState extends State<ReuseableContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MyUtility(context).height * 0.25,
        width: MyUtility(context).width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
            image: NetworkImage(
                widget.image.isNotEmpty ? widget.image : 'default_image_url'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.day,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Be Vietnam',
                ),
              ),
              Opacity(
                opacity: 0.50,
                child: Text(
                  widget.workout,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
