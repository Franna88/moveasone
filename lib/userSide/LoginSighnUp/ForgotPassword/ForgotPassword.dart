import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/EnterCode/EnterCode.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final email = TextEditingController(); // Controller for email input
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance
  String errorMessage = ''; // Error message to display if something goes wrong

  // Function to send reset email using Firebase
  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: email.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const EnterCode()), // Navigate to EnterCode page on success
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Update error message if the reset fails
      });
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
                            'FORGOT PASSWORD',
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
                  height: MyUtility(context).height * 0.04,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  child: Text(
                    "Enter the e-mail associated with your account and we'll send a code to reset your password",
                    style: TextStyle(
                      color: Color(0xFF006261),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MyUtility(context).height * 0.02,
                ),
                Container(
                  width: MyUtility(context).width / 1.2,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Center(
                      child: TextFormField(
                        controller: email,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'E-MAIL',
                          hintStyle: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 15,
                            fontFamily: 'Be Vietnam',
                            fontWeight: FontWeight.w100,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (errorMessage
                    .isNotEmpty) // Display error message if there's an issue
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                  height: MyUtility(context).height * 0.3,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.2,
                  height: MyUtility(context).height * 0.06,
                  child: ElevatedButton(
                    onPressed: resetPassword, // Call the resetPassword function
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'Submit',
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
      ),
    );
  }
}
