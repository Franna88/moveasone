import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:move_as_one/Services/auth_services.dart';
import 'package:move_as_one/userSide/LoginSighnUp/ForgotPassword/ForgotPassword.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/IntroVideoScreen.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/LoginComponents/SvgIconButton.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/CustomTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';
import 'package:move_as_one/commonUi/ModernGlassButton.dart';
import 'package:move_as_one/Services/debug_service.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // New color palette
  final primaryColor = const Color(0xFF6699CC); // Cornflower Blue
  final secondaryColor = const Color(0xFF94D8E0); // Pale Turquoise
  final accentColor = const Color(0xFFEDCBA4); // Toffee
  final highlightColor = const Color(0xFFF5DEB3); // Sand
  final backgroundColor = const Color(0xFFFFF8F0); // Light Sand/Cream

  @override
  void initState() {
    super.initState();
    DebugService().logWidgetLifecycle('Signin', 'initState');
    DebugService().logUserAction('view_signin_page', screen: 'Signin');
  }

  @override
  Widget build(BuildContext context) {
    DebugService().logWidgetLifecycle('Signin', 'build');
    return Material(
      child: SingleChildScrollView(
        child: Container(
            width: MyUtility(context).width,
            height: MyUtility(context).height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/welcomeImage.jpeg'),
                  alignment: Alignment.center,
                  fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MyUtility(context).height * 0.05,
                  ),
                  // Welcome text with frosted glass effect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MyUtility(context).width * 0.9,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                fontSize: 38,
                                fontFamily: 'belight',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Join a community that moves together',
                              style: TextStyle(
                                fontFamily: 'italiana',
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MyUtility(context).height * 0.04,
                  ),
                  // Login form with frosted glass effect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        width: MyUtility(context).width * 0.9,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'E-mail',
                            ),
                            SizedBox(
                              height: MyUtility(context).height * 0.02,
                            ),
                            PasswordTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  DebugService().logUserAction(
                                      'tap_forgot_password',
                                      screen: 'Signin');
                                  DebugService().logNavigation(
                                      'Signin', 'ForgotPassword');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()),
                                  );
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  // Login buttons with frosted glass effect
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          width: MyUtility(context).width * 0.9,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SvgIconButton(
                                    iconPath: 'images/apple.svg',
                                    onPressed: () {
                                      DebugService().logUserAction(
                                          'tap_apple_signin',
                                          screen: 'Signin');
                                    },
                                  ),
                                  SvgIconButton(
                                    iconPath: 'images/google.svg',
                                    onPressed: () {
                                      DebugService().logUserAction(
                                          'tap_google_signin',
                                          screen: 'Signin');
                                    },
                                  ),
                                  SizedBox(
                                    width: MyUtility(context).width * 0.45,
                                    height: MyUtility(context).height * 0.06,
                                    child: ModernGlassButton(
                                      buttonText: 'Sign in',
                                      onTap: () async {
                                        DebugService().logUserAction(
                                            'tap_signin',
                                            screen: 'Signin',
                                            parameters: {
                                              'email': _emailController.text,
                                              'has_password':
                                                  _passwordController
                                                      .text.isNotEmpty,
                                            });
                                        DebugService().startPerformanceTimer(
                                            'signin_process');

                                        await AuthService().Login(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            context: context);

                                        DebugService().endPerformanceTimer(
                                            'signin_process');
                                      },
                                      buttonColor: primaryColor,
                                      borderRadius: 30,
                                      height: MyUtility(context).height * 0.06,
                                      backgroundOpacity: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DebugService().logUserAction('tap_signup',
                                          screen: 'Signin');
                                      DebugService().logNavigation(
                                          'Signin', 'IntroVideo');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const IntroVideoScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
