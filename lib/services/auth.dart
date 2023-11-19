import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/functions.dart';
import '../models/userdata.dart';
import '../views/home.dart';
import '../views/login.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController adminPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  void LoginUser(context) async {
    try {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
      await auth.signInWithEmailAndPassword(
          email: email!.text, password: password!.text).then((value) {
        print("User Is Logged In");
        Navigator.pop(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>
              Home()), // Replace with your login screen widget
        );
      });
    } catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Error Message"),
          content: Text(e.toString()),
        );
      });
    }
  }

  // void adminLogin(context) async {
  //   showDialog(context: context, builder: (context) {
  //     return AlertDialog(
  //       title: Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //   });
  //   await FirebaseFirestore.instance.collection("admin").doc("adminLogin")
  //       .snapshots().forEach((element) {
  //     if (element.data()?['adminEmail'] == adminEmail.text &&
  //         element.data()?['adminPassword'] == adminPassword.text) {
  //       Navigator.pushAndRemoveUntil(context,
  //           MaterialPageRoute(builder: (context) => AdminPanel()), (
  //               route) => false);
  //     }
  //   }).catchError((e) {
  //     showDialog(context: context, builder: (context) {
  //       return AlertDialog(
  //         title: Text("Error Message"),
  //         content: Text(e.toString()),
  //       );
  //     });
  //   });
  // }


  void RegisterUser(context) async {
    try {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
      await auth.createUserWithEmailAndPassword(
          email: email!.text, password: password!.text).then((value) {
        print("User Is Registered");
        firestore.collection("user").add({
          "name": name.text,
          "email": email.text,
          "password": password.text,
          "uid": auth.currentUser!.uid
        });

        Navigator.pop(context);

        Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));
      });
    } catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Error Message"),
          content: Text(e.toString()),
        );
      });
    }
  }

  void logOutUser(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>
          Login()), // Replace with your login screen widget
    );
  }
}
