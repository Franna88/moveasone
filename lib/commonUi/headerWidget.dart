import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String header;
  const HeaderWidget({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Container(
      
      width: widthDevice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only( top: 25, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(width: 15,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                
                Container(
                  width: widthDevice * 0.80,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      header,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          
          Container(
          height: 0.2,
          width: widthDevice,
          color: Color.fromARGB(255, 128, 126, 126),
        ),
        ],
      ),
    );
  }
}
