import 'package:flutter/material.dart';
import 'package:move_as_one/admin/adminItems/memberManagement/ui/watchButton.dart';
import 'package:move_as_one/commonUi/trainerRatingContainer.dart';

class FullMemberWidget extends StatelessWidget {
  final String memberImage;
  final Color ratingContainerColor;
  final String memberName;
  final String trianingType;
  final String memberRating;
  final String experience;
  const FullMemberWidget({
    super.key,
    required this.ratingContainerColor,
    required this.memberImage,
    required this.memberName,
    required this.trianingType,
    required this.memberRating,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 30,
                backgroundImage: AssetImage(memberImage),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        memberName,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                      ),
                      TrainerRatingContainer(
                          color: ratingContainerColor, rating: memberRating),
                    ],
                  ),
                  Text(
                    trianingType,
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '$experience years experience',
                        style: TextStyle(
                          color: Color(0xFF006261),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: widthDevice * 0.09,
                      ),
                      WatchButton(
                        userId: '',
                        isWatched: false,
                      )
                    ],
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Colors.grey,
              )
            ],
          ),
        ],
      ),
    );
  }
}
