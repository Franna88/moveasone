import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/ResueableImage.dart';
import 'package:move_as_one/myutility.dart';

class Rachelle extends StatefulWidget {
  const Rachelle({super.key});

  @override
  State<Rachelle> createState() => _RachelleState();
}

class _RachelleState extends State<Rachelle> {
  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.22,
      child: Column(
        children: [
          SizedBox(
            height: MyUtility(context).height * 0.04,
          ),
          SizedBox(
            width: MyUtility(context).width / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rachelle',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontFamily: 'belight',
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFFAA5F3A),
                    fontSize: 15,
                    fontFamily: 'Be Vietnam',
                    fontWeight: FontWeight.w100,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.01,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: MyUtility(context).width * 0.02,
                ),
                ImageButton(
                  isSelected: _selectedIndex == 0,
                  onPressed: () {},
                  image: 'images/Beach.png',
                  description: 'Beach Stretch',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                ImageButton(
                  isSelected: _selectedIndex == 1,
                  onPressed: () {},
                  image: 'images/avatar2.png',
                  description: 'Running',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                ImageButton(
                  isSelected: _selectedIndex == 2,
                  onPressed: () {},
                  image: 'images/Running.png',
                  description: 'Outdoor',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                ImageButton(
                  isSelected: _selectedIndex == 3,
                  onPressed: () {},
                  image: 'images/avatar4.png',
                  description: 'Breathing',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
                ImageButton(
                  isSelected: _selectedIndex == 4,
                  onPressed: () {},
                  image: 'images/avatar5.png',
                  description: 'Beach Stretch',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
                ImageButton(
                  isSelected: _selectedIndex == 5,
                  onPressed: () {},
                  image: 'images/innerPeace.png',
                  description: 'Beach Stretch',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 5;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
