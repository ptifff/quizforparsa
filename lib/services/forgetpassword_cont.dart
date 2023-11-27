// Import the necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; // Import this for Navigator
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../views/app-constant.dart';
import '../views/inlog_ui.dart';

class ForgerPasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> forgetPasswordMethod(
      BuildContext context,
      String userEmail,
      ) async {
    try {
      EasyLoading.show(status: "Please wait");

      await _auth.sendPasswordResetEmail(email: userEmail);
      EasyLoading.dismiss();

      // Show success message using Flutter's SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset link sent to $userEmail"),
          backgroundColor: AppConstant.appScendoryColor,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to the Sign In screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();

      // Show error message using Flutter's SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: AppConstant.appScendoryColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
