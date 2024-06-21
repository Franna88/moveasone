import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/trainerRatingContainer.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class UserInfoContainer extends StatelessWidget {
  final String userPic;
  final Color ratingContainerColor;
  final String rating;
  final String userName;
  final String userRank;
  final String exercisesCompleted;
  const UserInfoContainer(
      {super.key,
      required this.userPic,
      required this.ratingContainerColor,
      required this.rating,
      required this.userName,
      required this.userRank,
      required this.exercisesCompleted});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 240, 230, 250),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30,
              backgroundImage: AssetImage(userPic),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'BeVietnam'
                      ),
                    ),
                    TrainerRatingContainer(
                        color: ratingContainerColor, rating: rating),
                  ],
                ),
                const SizedBox(height: 3,),
                Text(
                  userRank,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5,),
                Text(
                  exercisesCompleted,
                  style: TextStyle(
                      fontSize: 12,
                      color: UiColors().teal,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
