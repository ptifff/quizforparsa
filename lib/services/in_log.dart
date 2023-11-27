// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class SignInController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for password visibility
  var isPasswordVisible = false;

  Future<UserCredential?> signInMethod(
      String userEmail, String userPassword) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      // Handle the error in some way other than using Get.snackbar
      print("Error: $e");
      // You may want to throw the exception or return an error object
      return null;
    }
  }
  // void LoginUser(context) async {
  //   try {
  //     showDialog(context: context, builder: (context) {
  //       return AlertDialog(
  //         title: Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //       );
  //     });
  //     await _auth.signInWithEmailAndPassword(
  //         email: userEmail!.text, password: password!.text).then((value) {
  //       print("User Is Logged In");
  //       Navigator.pop(context);
  //
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) =>
  //             TopicSelection()), // Replace with your login screen widget
  //       );
  //     });
  //   } catch (e) {
  //     Navigator.pop(context);
  //     showDialog(context: context, builder: (context) {
  //       return AlertDialog(
  //         title: Text("Error Message"),
  //         content: Text(e.toString()),
  //       );
  //     });
  //   }
  }


