import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/myDivider.dart';

class LowMotivatedWidget extends StatelessWidget {
  final String image;
  final String name;
  final Widget bar;
  const LowMotivatedWidget({super.key, required this.image, required this.name, required this.bar});

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 25,
                          backgroundImage:
                              AssetImage(image),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        Spacer(),
                        bar
                      ],
                    ),
                  ),
                  MyDivider()
                ],
              ),
            );
  }
}