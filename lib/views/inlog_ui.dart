import 'package:demo_flutter/views/user_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../services/forget_password.dart';
import '../services/get_user.dart';
import '../services/in_log.dart';
import 'admin_selection.dart';
import 'app-constant.dart';
import 'sign-up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = SignInController();
  final GetUserDataController getUserDataController = GetUserDataController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  var isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScendoryColor,
          centerTitle: true,
          title: Text(
            "Sign In",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: userEmail,
                    cursorColor: AppConstant.appScendoryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Adjust the padding values
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: userPassword,
                    obscureText: !isPasswordVisible,
                    cursorColor: AppConstant.appScendoryColor,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: isPasswordVisible
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Adjust the padding values
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: AppConstant.appScendoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Material(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () async {
                      String email = userEmail.text.trim();
                      String password = userPassword.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error\nPlease enter all details",
                              style:
                              TextStyle(color: AppConstant.appTextColor),
                            ),
                            backgroundColor: AppConstant.appScendoryColor,
                          ),
                        );
                      } else {
                        UserCredential? userCredential = await signInController
                            .signInMethod(email, password);

                        var userData = await getUserDataController
                            .getUserData(userCredential!.user!.uid);

                        if (userCredential != null) {
                          if (userCredential.user!.emailVerified) {
                            if (userData[0]['isAdmin'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Success Admin Login\nLogin Successfully!",
                                    style: TextStyle(
                                        color: AppConstant.appTextColor),
                                  ),
                                  backgroundColor: AppConstant.appScendoryColor,
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminPanel(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TopicSelection(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Success User Login\nLogin Successfully!",
                                    style: TextStyle(
                                        color: AppConstant.appTextColor),
                                  ),
                                  backgroundColor: AppConstant.appScendoryColor,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Error\nPlease verify your email before login",
                                  style: TextStyle(
                                      color: AppConstant.appTextColor),
                                ),
                                backgroundColor: AppConstant.appScendoryColor,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error\nPlease try again",
                                style: TextStyle(
                                    color: AppConstant.appTextColor),
                              ),
                              backgroundColor: AppConstant.appScendoryColor,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppConstant.appScendoryColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppConstant.appScendoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}