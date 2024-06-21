import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class AdditionsalContainer extends StatefulWidget {
  final String image;
  final String header;
  final String discription;

  const AdditionsalContainer(
      {super.key,
      required this.image,
      required this.header,
      required this.discription});

  @override
  State<AdditionsalContainer> createState() => _AdditionsalContainerState();
}

class _AdditionsalContainerState extends State<AdditionsalContainer> {
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
            image: AssetImage(widget.image),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.header,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Be Vietnam',
                ),
              ),
              Opacity(
                opacity: 0.50,
                child: Text(
                  widget.discription,
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
