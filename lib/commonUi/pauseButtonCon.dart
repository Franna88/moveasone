import 'package:flutter/material.dart';

class PauseButtonCon extends StatelessWidget {
  const PauseButtonCon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.5),
      height: 80,
      width: 80,
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.white,
      ),
      child: Container(
        height: 2.5,
        width: 2.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(255, 204, 203, 203),
            ),
            const BoxShadow(
              color: Colors.white,
              spreadRadius: -1.0,
              blurRadius: 1.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(2.5),
        child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Colors.black12),
              ),
              shape: BoxShape.circle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 28,
                  width: 9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.grey, Colors.black],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  height: 28,
                  width: 9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.grey, Colors.black],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
