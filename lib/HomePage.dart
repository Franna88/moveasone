import 'package:flutter/material.dart';
import 'dart:ui'; // Import this for ImageFilter

import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/whattsappmao.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Apply the filter
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 0.0, sigmaY: 0.0), // No blur, just the color filter
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MyUtility(context).height * 0.1,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Move as ',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'belight',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'One',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'belight',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MyUtility(context).height * 0.5,
              ),
              SizedBox(
                width: MyUtility(context).width / 1.2,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Unlock your ',
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'belight',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'ultimate ',
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'belight',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'potential',
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'belight',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MyUtility(context).height * 0.05,
              ),
              SizedBox(
                width: MyUtility(context).width * 0.55,
                height: MyUtility(context).height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Signin()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF006261)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
