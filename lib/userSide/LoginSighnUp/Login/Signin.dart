import 'package:flutter/material.dart';
import 'package:move_as_one/Services/auth_services.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/Goal.dart';
import 'package:move_as_one/userSide/LoginSighnUp/ForgotPassword/ForgotPassword.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/LoginComponents/SvgIconButton.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/CustomTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';

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
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
            width: MyUtility(context).width,
            height: MyUtility(context).height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/new_photos/home_main.jpeg'),
                  alignment: Alignment.center,
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MyUtility(context).height * 0.09,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Text(
                    'Welcome back ',
                    style: TextStyle(
                      fontSize: 34,
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
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Text(
                    'champion!',
                    style: TextStyle(
                      fontSize: 44,
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
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.05,
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.02,
                ),
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
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
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
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.3,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SvgIconButton(
                        iconPath: 'images/apple.svg',
                        onPressed: () {},
                      ),
                      SvgIconButton(
                        iconPath: 'images/google.svg',
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: MyUtility(context).width * 0.45,
                        height: MyUtility(context).height * 0.06,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(primaryColor),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () async {
                                await AuthService().Login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context);
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.01,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Row(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Goal()),
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
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
