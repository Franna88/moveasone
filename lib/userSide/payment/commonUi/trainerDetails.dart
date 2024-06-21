import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/trainerRatingContainer.dart';

class TrainerDetail extends StatelessWidget {
  final String trainerImage;
  final Color ratingContainerColor;
  final String trainerName;
  final String trainerTag;
  final String trainerRating;
  const TrainerDetail(
      {super.key,
      required this.trainerName,
      required this.trainerTag,
      required this.trainerRating,
      required this.ratingContainerColor, required this.trainerImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trainer',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w400
          ),
        ),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 18,
              backgroundImage: AssetImage(trainerImage),
            ),
            const SizedBox(width: 10,),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      trainerName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    TrainerRatingContainer(
                        color: ratingContainerColor, rating: trainerRating),
                  ],
                ),
                Text(
                  trainerTag,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
