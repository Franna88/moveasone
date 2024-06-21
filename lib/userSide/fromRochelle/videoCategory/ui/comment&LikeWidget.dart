import 'package:flutter/material.dart';

class CommentLikeWidget extends StatefulWidget {
  final IconData icon;
  String count;
  CommentLikeWidget({super.key, required this.count, required this.icon});

  @override
  State<CommentLikeWidget> createState() => _CommentLikeWidgetState();
}

class _CommentLikeWidgetState extends State<CommentLikeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Icon(
            widget.icon,
            color: Colors.white,
            size: 25
            ,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.count,
            style: TextStyle(fontSize: 12, height: 1, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
