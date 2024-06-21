import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/Home/AdditionalResources/AdditionalResources.dart';
import 'package:move_as_one/userSide/Home/GetStartedComponents/Rachelle.dart';
import 'package:move_as_one/userSide/Home/Motivational/Motivational.dart';
import 'package:move_as_one/userSide/Home/YourWorkouts/YourWorkout.dart';
import 'package:move_as_one/myutility.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MyUtility(context).width,
            height: MyUtility(context).height / 1.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bicepFlex.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MyUtility(context).height * 0.21,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.15,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'You ',
                            style: TextStyle(
                              color: Color(0xFF006261),
                              fontSize: 44,
                              fontFamily: 'belight',
                              height: 0.0,
                            ),
                          ),
                          TextSpan(
                            text: 'can',
                            style: TextStyle(
                              color: Color(0xFFAA5F3A),
                              fontSize: 44,
                              fontFamily: 'belight',
                              height: 0.0,
                            ),
                          ),
                          TextSpan(
                            text: ' be \nGreat',
                            style: TextStyle(
                              color: Color(0xFF006261),
                              fontSize: 44,
                              fontFamily: 'belight',
                              height: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    width: MyUtility(context).width / 1.15,
                    child: Text(
                      'You have the power to decide to be great. Lets start now! ',
                      style: TextStyle(
                        color: Color(0xA5006261),
                        fontSize: 16,
                        fontFamily: 'Be Vietnam',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.15,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MyUtility(context).width * 0.5,
                      height: MyUtility(context).height * 0.06,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: ShapeDecoration(
                        color: Color(0xFF006261),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Let’s Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'belight',
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Rachelle(),
          YourWorkouts(),
          Motivational(),
          AdditionalResources()
        ],
      ),
    );
  }
}
