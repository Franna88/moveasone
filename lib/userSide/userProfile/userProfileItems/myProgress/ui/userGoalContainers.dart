import 'package:flutter/material.dart';

class UserGoalContainers extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String amount;
  final String infoType;
  const UserGoalContainers(
      {super.key,
      required this.color,
      required this.icon,
      required this.amount,
      required this.infoType});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Material(
        elevation: 6,
        color: color,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: widthDevice * 0.24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  infoType,
                  style: TextStyle(
                    fontFamily: 'BeVietnam',
                    color: Color.fromARGB(255, 107, 107, 107),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
