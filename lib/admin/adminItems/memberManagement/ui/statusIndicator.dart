import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final Widget barType;
  final String progressType;
  final Color textColor;
  const StatusIndicator(
      {super.key,
      required this.barType,
      required this.progressType,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 20),
      child: Row(
        children: [
          barType,
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                progressType,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  letterSpacing: 0.10,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit.',
                style: TextStyle(
                  color: Color(0xFF525252),
                  fontSize: 10,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0.40,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
