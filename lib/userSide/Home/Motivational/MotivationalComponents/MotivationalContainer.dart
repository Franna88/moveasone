import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class MotivationalContainer extends StatefulWidget {
  final String image;
  final String motivational;
  final Color color;

  const MotivationalContainer(
      {super.key,
      required this.image,
      required this.motivational,
      required this.color});

  @override
  State<MotivationalContainer> createState() => _MotivationalContainerState();
}

class _MotivationalContainerState extends State<MotivationalContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MyUtility(context).height * 0.25,
        width: MyUtility(context).width / 2.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
            image: AssetImage(widget.image),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: MyUtility(context).height * 0.05,
                child: Text(
                  widget.motivational,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 18,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
