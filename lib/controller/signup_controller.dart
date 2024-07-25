import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pitchme/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/screen/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitchme/controller/getdivcetoken.dart';

// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_field

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetDeviceTokenController getDeviceTokenController =
      Get.put(GetDeviceTokenController());

  ///=============for password visibility
  ///
  var isPasswordVisibility = false.obs;

  ///=============sign up method
  ///

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPassword,
    String userDeviceToken,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      ///============sent user email verification
      ///
      final User? user = userCredential.user;

      ///============= device token

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        userImg: user!.photoURL.toString(),
        userDeviceToken: getDeviceTokenController.deviceToken.toString(),
      );

      ///================add data in firebase
      ///
      if (userCredential != null) {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
        print("store");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
          colorText: Colors.black);
    }
  }

  Future<SigninScreen> signOut() async {
    await FirebaseAuth.instance.signOut();
    return const SigninScreen();
  }
}
