// sign_up_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../views/app-constant.dart';
import '../views/user_selection.dart';
import 'user_model.dart';

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUpMethod(
      BuildContext context,
      String userName,
      String userEmail,
      String userPhone,
      String userCity,
      String userPassword,
      String userDeviceToken,
      ) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // send email verification
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userImg: '',
        userDeviceToken: userDeviceToken,
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: userCity,
      );

      // add data into the database
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      EasyLoading.dismiss();

      // Navigate to the home screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TopicSelection()), // Assuming you have TopicSelection class
      );

      return userCredential;

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
          backgroundColor: AppConstant.appScendoryColor,
        ),
      );
      return null;
    }
  }
}
