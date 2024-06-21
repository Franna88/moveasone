import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SatusPaymentBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps = 12;

  SatusPaymentBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;

    return CircularPercentIndicator(
      radius: 30.0,
      lineWidth: 6.0,
      percent: progress,
      center: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(
                text: 'Status\n',
                style: TextStyle(
                  color: Color(0xFF525252),
                  fontSize: 10,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0.40,
                ),
              ),
              TextSpan(
                text: "$currentStep of 12",
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )),
      progressColor: Color(0xFFDA1E28),
      backgroundColor: Color.fromARGB(106, 218, 30, 39),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
