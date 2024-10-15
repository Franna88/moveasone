import 'package:flutter/material.dart';

class CategoryModel {
  final String workoutImage;
  final String categoryName;
  bool selected;
  String selectDifficultyLevel;
  Function() onTap;

  CategoryModel(
      {required this.categoryName,
      required this.workoutImage,
      this.selected = false,
      this.selectDifficultyLevel = '',
      required this.onTap});
}

List workoutCategories = [
  CategoryModel(
    categoryName: 'At Home',
    workoutImage: 'images/placeHolder2.jpg',
    onTap: () {
      //Navigator.push(context,MaterialPageRoute(builder: (context) => const ),);

      //ADD PAGE INDEX
    },
  ),
  CategoryModel(
    categoryName: 'Functional Training',
    workoutImage: 'images/placeholder3.jpg',
    onTap: () {
      //ADD PAGE INDEX
    },
  ),
  CategoryModel(
    categoryName: 'Gym Workout',
    workoutImage: 'images/placeHolder2.jpg',
    onTap: () {
      //ADD PAGE INDEX
    },
  ),
  /*CategoryModel(
    categoryName: 'Special Challenge',
    workoutImage: 'images/placeholder3.jpg',
    onTap: () {
      //ADD PAGE INDEX
    },
  ),
  CategoryModel(
    categoryName: 'Outdoor',
    workoutImage: 'images/placeHolder2.jpg',
    onTap: () {
      //ADD PAGE INDEX
    },
  ),*/
];
