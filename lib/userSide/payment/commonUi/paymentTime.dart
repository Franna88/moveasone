import 'package:flutter/material.dart';

class PaymentTime extends StatelessWidget {
  final String paymentTime;
  const PaymentTime({super.key, required this.paymentTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 15, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                    'Time',
                    style: TextStyle(
                      fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    paymentTime,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
        ],
      ),
    );
  }
}
