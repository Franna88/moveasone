import 'package:flutter/material.dart';
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
    return Material(
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/startImage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  TextSpan(
                    text: 'One',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'belight',
                      color: UiColors().teal,
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
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    TextSpan(
                      text: 'ultimate ',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'belight',
                        color: UiColors().teal,
                      ),
                    ),
                    TextSpan(
                      text: 'potential',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'belight',
                        color: Color(0xFF1E1E1E),
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
      ),
    );
  }
}
