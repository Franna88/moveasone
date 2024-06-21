import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';

import 'package:move_as_one/myutility.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: MyUtility(context).width,
          height: MyUtility(context).height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/password.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                  width: MyUtility(context).width,
                  height: MyUtility(context).height * 0.1,
                  decoration: BoxDecoration(color: Colors.white),
                  child: SizedBox(
                    width: MyUtility(context).width / 1.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.keyboard_arrow_left, color: Colors.black),
                        Text(
                          'RESET PASSWORD',
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 15,
                            fontFamily: 'Be Vietnam',
                            fontWeight: FontWeight.w100,
                            height: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: MyUtility(context).width * 0.01,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: MyUtility(context).height * 0.05,
              ),
              SizedBox(
                width: MyUtility(context).width / 1.2,
                child: Text(
                  "Enter a new password",
                  style: TextStyle(
                    color: Color(0xFF006261),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MyUtility(context).height * 0.05,
              ),
              PasswordTextField(
                controller: email,
                hintText: 'New password',
              ),
              SizedBox(
                height: MyUtility(context).height * 0.01,
              ),
              PasswordTextField(
                controller: email,
                hintText: 'Re-enter new password',
              ),
              SizedBox(
                height: MyUtility(context).height * 0.25,
              ),
              SizedBox(
                width: MyUtility(context).width / 1.2,
                height: MyUtility(context).height * 0.06,
                child: ElevatedButton(
                  onPressed: () {},
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
                      'Reset',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
