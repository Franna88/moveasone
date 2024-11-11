import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase import
import 'package:move_as_one/userSide/LoginSighnUp/Signup/SignupComponents/PasswordTextField.dart';
import 'package:move_as_one/myutility.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  Future<void> resetPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    try {
      // Code to reset the password would go here
      // Since this is a password reset via link, actual reset logic would be handled through Firebase's email link
      Navigator.pop(context); // Return to login after successful reset
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

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
                controller: passwordController,
                hintText: 'New password',
              ),
              SizedBox(
                height: MyUtility(context).height * 0.01,
              ),
              PasswordTextField(
                controller: confirmPasswordController,
                hintText: 'Re-enter new password',
              ),
              SizedBox(
                height: MyUtility(context).height * 0.25,
              ),
              if (errorMessage.isNotEmpty) // Display error message
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: MyUtility(context).width / 1.2,
                height: MyUtility(context).height * 0.06,
                child: ElevatedButton(
                  onPressed: resetPassword, // Call resetPassword function
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Color(0xFF006261)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
