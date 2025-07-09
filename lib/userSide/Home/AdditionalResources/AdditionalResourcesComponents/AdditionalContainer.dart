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
    return Container(
      height: MyUtility(context).height * 0.25,
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        minWidth: 200,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage(widget.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  widget.header,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  widget.discription,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
