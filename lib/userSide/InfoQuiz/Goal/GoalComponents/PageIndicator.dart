import 'package:flutter/material.dart';
import 'package:move_as_one/myutility.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;

  const PageIndicator({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MyUtility(context).width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Row(
            children: [
              Text(
                '${currentPage + 1}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 4),
              Text(
                '/ 6',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
