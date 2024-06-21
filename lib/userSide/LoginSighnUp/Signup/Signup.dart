import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/InfoQuiz/Goal/Goal.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/LoginComponents/SvgIconButton.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/CustomTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PrivacyPolicyCheckbox.dart';
import 'package:move_as_one/myutility.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final email = TextEditingController();
  final password = TextEditingController();
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
                  controller: email,
                  hintText: 'Name',
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.02,
                ),
                CustomTextField(
                  controller: email,
                  hintText: 'E-mail',
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.02,
                ),
                PasswordTextField(
                  controller: password,
                  hintText: 'Password',
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.02,
                ),
                PasswordTextField(
                  controller: password,
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
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF006261)),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
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
