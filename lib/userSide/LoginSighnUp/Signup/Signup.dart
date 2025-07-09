import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:move_as_one/Services/auth_services.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/LoginComponents/SvgIconButton.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/Signin.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/CustomTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PrivacyPolicyCheckbox.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/commonUi/ModernGlassButton.dart';

class Signup extends StatefulWidget {
  final String goal;
  final String gender;
  final String height;
  final String weight;
  final String weightUnit;
  final String age;
  final String activityLevel;

  const Signup(
      {super.key,
      required this.goal,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.weightUnit,
      required this.activityLevel});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void_signup() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    //check to confirm if passwords are the same before continuing.
    if (password != confirmPassword) {
      Fluttertoast.showToast(
          msg: 'Passwords do not match.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }

    // Proceed with signup
    if (password == confirmPassword) {
      await AuthService().Signup(
          userName: _nameController.text,
          email: _emailController.text,
          password: password,
          goal: widget.goal,
          weight: widget.weight,
          gender: widget.gender,
          age: widget.age,
          height: widget.height,
          weightUnit: widget.weightUnit,
          activityLevel: widget.activityLevel,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
            width: MyUtility(context).width,
            height: MyUtility(context).height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/new_photos/IMG_5616.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MyUtility(context).height * 0.05,
                  ),
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
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 42,
                                fontFamily: 'belight',
                                color: Color(0xFF1E1E1E),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            CustomTextField(
                              controller: _nameController,
                              hintText: 'Name',
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
                              height: MyUtility(context).height * 0.02,
                            ),
                            PasswordTextField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirm password',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                  width: MyUtility(context).width / 1.2,
                                  child: PrivacyPolicyCheckbox()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          width: MyUtility(context).width * 0.9,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
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
                                    onPressed: () {},
                                  ),
                                  SvgIconButton(
                                    iconPath: 'images/google.svg',
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                    width: MyUtility(context).width * 0.45,
                                    height: MyUtility(context).height * 0.06,
                                    child: ModernGlassButton(
                                      buttonText: 'Sign Up',
                                      onTap: void_signup,
                                      buttonColor: Color(0xFF006261),
                                      borderRadius: 30,
                                      height: MyUtility(context).height * 0.06,
                                      backgroundOpacity: 0.4,
                                      icon: Icons.keyboard_arrow_right,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account",
                                    style: TextStyle(
                                      color: Color(0xFF707070),
                                      fontSize: 18.0,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Signin()),
                                      );
                                    },
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                        color: Color(0xFF006261),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color:
                                                Colors.black.withOpacity(0.3),
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
