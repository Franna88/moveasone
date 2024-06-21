import 'package:flutter/material.dart';

class PaymentDate extends StatelessWidget {
  final String paymentDate;
  const PaymentDate({super.key, required this.paymentDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                    'Date',
                    style: TextStyle(
                      fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    paymentDate,
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
