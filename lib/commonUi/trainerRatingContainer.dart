import 'package:flutter/material.dart';

class TrainerRatingContainer extends StatelessWidget {
  final Color color;
  final String rating;
  const TrainerRatingContainer(
      {super.key, required this.color, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        height: 16,
        width: 35,
        decoration: ShapeDecoration(
          color: color,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
        ),
        child: Center(
          child: Text(
            rating,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5,
            ),
          ),
        ),
      ),
    );
  }
}
