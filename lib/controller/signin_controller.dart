import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore_for_file: unused_import

// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_field

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///=============for password visibility
  ///
  var isPasswordVisibility = false.obs;

  ///=============sign in method
  ///
  Future<UserCredential?> signInMethod(
    String userEmail,
    String userPassword,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);

      ///============sent user email verification
      ///
      // Uncomment and adjust if you need to send email verification
      // if (userCredential.user != null && !userCredential.user!.emailVerified) {
      //   await userCredential.user!.sendEmailVerification();
      // }

      ///================add data in firebase
      ///

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error is : ${e.toString()}");

      Get.snackbar(
        'Error',
        e.message ?? 'An unknown error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.black,
      );
    } catch (e) {
      // Handle other potential errors
      print("Unexpected error: ${e.toString()}");
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.black,
      );
    }

    return null;
  }
}
