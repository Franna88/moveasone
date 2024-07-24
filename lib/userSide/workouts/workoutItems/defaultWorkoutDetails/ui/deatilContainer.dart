import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class DetailContainer extends StatelessWidget {
  final String assetName;
  final String difficulty;
  final String exerciseType;
  final String duration;
  final String kcalAmount;
  const DetailContainer(
      {super.key,
      required this.assetName,
      required this.difficulty,
      required this.exerciseType,
      required this.duration,
      required this.kcalAmount});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      height: heightDevice * 0.40,
      width: widthDevice,
      decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(assetName), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 30,
                ),
                Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 25,
                ),
              ],
            ),
            Spacer(),
            Text(
              difficulty,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              exerciseType,
              style: TextStyle(fontSize: 23, color: UiColors().brown),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: duration,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: kcalAmount,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
