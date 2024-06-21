import 'dart:ui';

import 'package:move_as_one/commonUi/uiColors.dart';

class AllMembersModel {
  final String memberImage;
  final Color ratingContainerColor;
  final String memberName;
  final String trianingType;
  final String memberRating;
  final String experience;

  AllMembersModel(
      {required this.experience,
      required this.memberImage,
      required this.memberName,
      required this.memberRating,
      required this.ratingContainerColor,
      required this.trianingType});
}

List fullMemberInfo = [
  AllMembersModel(
      experience: '7',
      memberImage: 'images/pfp1.jpg',
      memberName: 'Anika Workman',
      memberRating: '4.8',
      ratingContainerColor: UiColors().teal,
      trianingType: 'High Intensity Training'),
  AllMembersModel(
      experience: '9',
      memberImage: 'images/pfp2.jpg',
      memberName: 'Abram Ekstrom',
      memberRating: '4.8',
      ratingContainerColor: UiColors().teal,
      trianingType: 'High Intensity Training'),
  AllMembersModel(
      experience: '5',
      memberImage: 'images/pfp3.jpg',
      memberName: 'Ryan Prestenwood',
      memberRating: '4.8',
      ratingContainerColor: UiColors().teal,
      trianingType: 'High Intensity Training'),
  AllMembersModel(
      experience: '3',
      memberImage: 'images/pfp4.png',
      memberName: 'Roger Ekstrom',
      memberRating: '4.8',
      ratingContainerColor: UiColors().teal,
      trianingType: 'High Intensity Training'),
  AllMembersModel(
      experience: '6',
      memberImage: 'images/pfp5.jpeg',
      memberName: 'Lena Rosser',
      memberRating: '4.8',
      ratingContainerColor: UiColors().teal,
      trianingType: 'High Intensity Training'),
  AllMembersModel(
      experience: '7',
      memberImage: 'images/pfp6.jpeg',
      memberName: 'Emerson Scheifer',
      memberRating: '4.8',
      ratingContainerColor: UiColors().teal,
      trianingType: 'High Intensity Training'),
];
