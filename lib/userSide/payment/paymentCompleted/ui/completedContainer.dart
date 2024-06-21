import 'package:flutter/material.dart';

class CompletedContainer extends StatelessWidget {
  const CompletedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    var heightDevice = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: heightDevice * 0.15,
        width: widthDevice,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 0.5,
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15,),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 102, 204, 136),
                      shape: CircleBorder(),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    'PAYMENT COMPLETED!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Text(
                textAlign: TextAlign.center,
                'You\'ve booked a new appointment \nwith your trainer.',
                style: TextStyle(
                  color: Color.fromARGB(255, 134, 132, 132),
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
