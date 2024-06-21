import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/mainContainer.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/exercisesAmount.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/hiFiveAmount.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/profileHeader.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/profileInteractButton.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/profileProtected.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/userImage.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/userNameTag.dart';
import 'package:move_as_one/userSide/userProfile/userProfileItems/userProfileLocked/ui/userStatus.dart';

class UserProfileLocked extends StatelessWidget {
  const UserProfileLocked({super.key});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    return MainContainer(
      children: [
        ProfileHeader(header: 'SEND HI-FIVE'),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserImage(userImage: 'images/comment1.jpg'),
              const SizedBox(
                width: 30,
              ),
              //AMOUNT OF EXERCISES ON USER PROFILE
              ExercisesAmount(amountOfExercises: '103'),

              const SizedBox(
                width: 30,
              ),
              //AMOUNT OF HIGH FIVES AWARDED TO USER
              HiFiveAmount(hiFivesAmount: '48'),
            ],
          ),
        ),
        UserNameTag(userName: 'Anika Mango', userTag: '@anikko_334'),
        Align(
          alignment: Alignment.centerLeft,
          child: UserStatus(userStatus: 'I love pizza more than fitness'),
        ),
        
        ProfileInteractButton(
          buttonChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                'Send Hi-Five',
                style: TextStyle(
                  fontFamily: 'BeVietnam',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.waves),
            ],
          ),
          onTap: () {
            //ADD LOGIC HERE
          },
        ),
        
        ProfileInteractButton(
          buttonChild: Text(
            textAlign: TextAlign.center,
            'Send Congrats',
            style: TextStyle(
              fontFamily: 'BeVietnam',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          onTap: () {
            //ADD LOGIC HERE
          },
        ),
        ProfileInteractButton(
          buttonChild: Text(
            textAlign: TextAlign.center,
            'Send Well done',
            style: TextStyle(
              fontFamily: 'BeVietnam',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          onTap: () {
            //ADD LOGIC HERE
          },
        ),
        SizedBox(height: heightDevice * 0.06,),
        ProfileProtected()
      ],
    );
  }
}
