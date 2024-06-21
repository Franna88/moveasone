import 'package:flutter/material.dart';

class EstimatedCost extends StatelessWidget {
  final String estimatedCost;
  const EstimatedCost({super.key, required this.estimatedCost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Estimated Cost',
            style: TextStyle(
              fontFamily: 'Inter',
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          Text(
            estimatedCost,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
