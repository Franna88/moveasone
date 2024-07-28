import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:move_as_one/Services/auth_services.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/Goal.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/LoginComponents/SvgIconButton.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/CustomTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PrivacyPolicyCheckbox.dart';
import 'package:move_as_one/myutility.dart';

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
    //awaits on sign ups until passwords are the same.
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
          weightUnit: widget.weight,
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
                image: AssetImage('images/signUp.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MyUtility(context).height * 0.1,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 42,
                      fontFamily: 'belight',
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.05,
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
                SizedBox(
                  height: MyUtility(context).height * 0.2,
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
                          onPressed: void_signup,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF006261)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      )
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
                          color: Color(
                              0xFF707070), // Color from the provided hex code
                          fontSize: 18.0,
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
                          style:
                              TextStyle(color: Color(0xFF006261), fontSize: 18),
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
