import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/glassEffect.dart';

class OtherTrainersContainer extends StatelessWidget {
  const OtherTrainersContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              height: 40,
              child: Stack(
                children: [
                  //PLACEHOLDER IMAGES
                  Positioned(
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 18,
                      backgroundImage: AssetImage('images/comment1.jpg'),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 18,
                      backgroundImage: AssetImage('images/comment2.jpg'),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 18,
                      backgroundImage: AssetImage('images/comment3.jpg'),
                    ),
                  ),
                  Positioned(
                    left: 110,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 18,
                      backgroundImage: AssetImage('images/comment1.jpg'),
                    ),
                  ),
                  Positioned(
                    left: 135,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: ShapeDecoration(
                        color: Color.fromARGB(255, 24, 23, 23),
                        shape: CircleBorder(),
                      ),
                      child: Center(
                        //NUMBER CHANGE BASSED ON AMOUNT OF TRAINERS
                        child: Text(
                          '+25',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: Text(
              'Other Trainers',
              style: TextStyle(fontSize: 18, color: Colors.white, height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
