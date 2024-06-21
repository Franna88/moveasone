import 'package:flutter/material.dart';

class CommentModel {
  final String userName;
  final String timeStamp;
  final String assetName;
  final String userComment;
  final String likes;

  CommentModel(
      {required this.assetName,
      required this.likes,
      required this.timeStamp,
      required this.userComment,
      required this.userName});
}

List dummyComments = [
  CommentModel(
      assetName: 'images/comment1.jpg',
      likes: '16 likes',
      timeStamp: '32m',
      userComment: 'Lorem ipsum dolor sit amet constctuer',
      userName: 'Kaiya Babtista'),
  CommentModel(
      assetName: 'images/comment2.jpg',
      likes: '4 likes',
      timeStamp: '1h',
      userComment: 'Lorem ipsum dolor sit ',
      userName: 'Ryanm  Rhiel'),
  CommentModel(
      assetName: 'images/comment3.jpg',
      likes: 'like',
      timeStamp: '2h',
      userComment: 'sit amet constctuer',
      userName: 'Allison Septimus'),
  CommentModel(
      assetName: 'images/comment1.jpg',
      likes: '2 likes',
      timeStamp: '1d',
      userComment: 'Lorem constctuer',
      userName: 'Kaiya Babtista'),
  CommentModel(
      assetName: 'images/comment2.jpg',
      likes: '16 likes',
      timeStamp: '4d',
      userComment: 'Lorem ipsum dolor sit amet constctuer',
      userName: 'Ryanm  Rhiel'),
];
