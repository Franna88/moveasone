import 'package:flutter/material.dart';
import 'package:move_as_one/userSide/LoginSighnUp/EnterCode/EnterCodeComponents/ContainerVerificationCode.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/ResetPassword/ResetPassword.dart';

class EnterCode extends StatefulWidget {
  const EnterCode({super.key});

  @override
  State<EnterCode> createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final verificationCodeController = TextEditingController();
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
                          'VERIFY',
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
                  "Enter the code we just sent",
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
              ContainerVerificationCode(),
              SizedBox(
                height: MyUtility(context).height * 0.02,
              ),
              SizedBox(
                width: MyUtility(context).width / 1.2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Resend code',
                      style: TextStyle(
                        color: Color(0xFF006261),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0.09,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MyUtility(context).height * 0.22,
              ),
              SizedBox(
                width: MyUtility(context).width / 1.2,
                height: MyUtility(context).height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResetPassword()),
                              );
                  },
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
                      'Next',
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
