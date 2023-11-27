// signUp.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../services/up_sign.dart';
import 'app-constant.dart';
import 'inlog_ui.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordVisible = true;
  final SignUpController signUpController = SignUpController();
  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appScendoryColor,
            centerTitle: true,
            title: Text(
              "Sign Up",
              style: TextStyle(color: AppConstant.appTextColor),
            ),
          ),
          body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
    child: Container(
    child: Column(
    children: [
    SizedBox(
    height: MediaQuery.of(context).size.height / 20,
    ),
    Container(
    alignment: Alignment.center,
    child: Text(
    "Welcome to my app",
    style: TextStyle(
    color: AppConstant.appScendoryColor,
    fontWeight: FontWeight.bold,
    fontSize: 16.0),
    ),
    ),
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
    controller: username,
    cursorColor: AppConstant.appScendoryColor,
    keyboardType: TextInputType.name,
    decoration: InputDecoration(
    hintText: "UserName",
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
    controller: userPhone,
    cursorColor: AppConstant.appScendoryColor,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
    hintText: "Phone",
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
    controller: userCity,
    cursorColor: AppConstant.appScendoryColor,
    keyboardType: TextInputType.streetAddress,
    decoration: InputDecoration(
    hintText: "City",
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
    obscureText: isPasswordVisible,
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
    "SIGN UP",
    style: TextStyle(color: AppConstant.appTextColor),
    ),
    onPressed: () async {
    String name = username.text.trim();
    String email = userEmail.text.trim();
    String phone = userPhone.text.trim();
    String city = userCity.text.trim();
    String password = userPassword.text.trim();
    String userDeviceToken = '';

    if (name.isEmpty ||
    email.isEmpty ||
    phone.isEmpty ||
    city.isEmpty ||
    password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("Please enter all details"),
    backgroundColor: AppConstant.appScendoryColor,
    duration: Duration(seconds: 2),
    ),
    );
    } else {
    UserCredential? userCredential = await signUpController.signUpMethod(
    context,
    name,
    email,
    phone,
    city,
    password,
    userDeviceToken,
    );

    if (userCredential != null) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("Verification email sent. Please check your email."),
    backgroundColor: AppConstant.appScendoryColor,
    duration: Duration(seconds: 2),
    ),
    );

    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => SignInScreen()),
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
    "Already have an account? ",
    style: TextStyle(color: AppConstant.appScendoryColor),
          ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignInScreen()),
          ),
          child: Text(
            "Sign In",
            style: TextStyle(
                color: AppConstant.appScendoryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        ],
      )
      ],
      ),
      ),
      ),
      );
      });
  }
}
