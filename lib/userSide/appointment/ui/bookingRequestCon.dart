import 'package:flutter/material.dart';
import 'package:move_as_one/commonUi/uiColors.dart';

class BookingRequestCon extends StatelessWidget {
  final String userName;
  const BookingRequestCon({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      width: widthDevice * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 240, 230, 250),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('images/startImage.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Request for',
                  style: TextStyle(
                      fontSize: 10,
                      color: UiColors().teal,
                      //fontWeight: FontWeight.w400,
                      fontFamily: 'Inter'),
                ),
                const SizedBox(height: 10,),
                
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'BeVietnam'
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 25,
            ),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}