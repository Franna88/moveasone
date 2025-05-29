import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:move_as_one/admin/commonUi/commonButtons.dart';
import 'package:move_as_one/commonUi/uiColors.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UiColors colors = UiColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.paleTurquoise.withOpacity(0.7),
              colors.bgLight,
              colors.lightCoral.withOpacity(0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Semi-transparent background image
            Opacity(
              opacity: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/new_photos/home_main2.jpeg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.9),
                      BlendMode.lighten,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MyUtility(context).height * 0.06,
                  ),
                  // Logo area with gentle shadow
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: colors.bgLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colors.cornflowerBlue.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Move as ',
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily: 'belight',
                              fontWeight: FontWeight.bold,
                              color: colors.textDark.withOpacity(0.8),
                              letterSpacing: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: 'One',
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily: 'belight',
                              fontWeight: FontWeight.bold,
                              color: colors.toffee,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main message with background card
                        Container(
                          width: MyUtility(context).width / 1.1,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: colors.bgLight.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: colors.lavender.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Unlock your',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontFamily: 'belight',
                                  fontWeight: FontWeight.bold,
                                  color: colors.textDark.withOpacity(0.9),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'ultimate potential',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontFamily: 'belight',
                                  fontWeight: FontWeight.bold,
                                  color: colors.cornflowerBlue,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Join a community that moves together',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'BeVietnam',
                                  color: colors.textDark.withOpacity(0.7),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Buttons area
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        CommonButtons(
                          buttonText: 'Get Started',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signin()),
                            );
                          },
                          buttonColor: colors.cornflowerBlue,
                          width: MyUtility(context).width * 0.7,
                          height: 56,
                          borderRadius: 30,
                          elevated: true,
                          icon: Icons.arrow_forward_rounded,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Add action for "Learn more"
                          },
                          child: Text(
                            'Learn more about us',
                            style: TextStyle(
                              color: colors.toffee,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: colors.toffee.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
