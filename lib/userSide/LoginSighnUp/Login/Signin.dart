import 'package:flutter/material.dart';
import 'package:move_as_one/MyHome.dart';
import 'package:move_as_one/userSide/LoginSighnUp/ForgotPassword/ForgotPassword.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Login/LoginComponents/SvgIconButton.dart';
import 'package:move_as_one/myutility.dart';
import 'package:move_as_one/userSide/LoginSighnUp/Signup/Signup.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: MyUtility(context).width,
          height: MyUtility(context).height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/welcomeBack.png'),
              alignment: Alignment(-0.4, 1),
              fit: BoxFit.fitHeight
              
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
                  'Welcome back ',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: 'belight',
                    color: Color(0xFF1E1E1E),
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
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              SizedBox(
                height: MyUtility(context).height * 0.05,
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
                  child: TextFormField(
                    controller: email,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelText: 'E-mail',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'raleway',
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
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
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontFamily: 'raleway',
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
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
                      style: TextStyle(color: Color(0xFF006261), fontSize: 18),
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF006261)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyHome()),
  );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
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
                                    builder: (context) => const Signup()),
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
    );
  }
}
