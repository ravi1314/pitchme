import 'package:get/get.dart';
import 'package:pitchme/model/user_model.dart';
import 'package:pitchme/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: avoid_print, prefer_const_constructors

class GoogleSigninController extends GetxController {
  ///------------googlesignin  object
  ///-----------from Google Sign in class

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///-------------create method (future) for Sign in with Google

  // ignore: non_constant_identifier_names
  Future<void> signinWithGoogle() async {
    // final GetDeviceTokenController getDeviceTokenController =
    //     Get.put(GetDeviceTokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        ///--------------store user
        ///
        final User? user = userCredential.user;

        ///======== if user is not empty
        ///
        if (user != null) {
          UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              
              userImg: user.photoURL.toString(),
              userDeviceToken: '',
             );

          ///---------------------store in firestore------------------------///

          await FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .set(userModel.toMap());
          //---------------dispose loading

          Get.offAll(() => HomeScreen());
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
