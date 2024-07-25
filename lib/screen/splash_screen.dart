import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pitchme/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/screen/signin_screen.dart';
import 'package:pitchme/screen/signup_screen.dart';
import 'package:pitchme/screen/profile_screen.dart';
import 'package:pitchme/utiles/hidenDrawer_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (auth.currentUser != null) {
        Get.off(() => HomeScreen());
      } else {
        Get.off(() => SigninScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 370,
              width: 600,
              child: Lottie.network(
                  'https://lottie.host/d1807866-aaca-4b04-8cff-2d98b8635f1b/ljRWA8uiJ3.json'),
            ),
            Text(
              "PitchMe",
              style: GoogleFonts.eduTasBeginner(
                  textStyle: const TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            Column(
              children: [
                Text(
                  "From Vision to Victory",
                  style: GoogleFonts.eduTasBeginner(
                      textStyle: TextStyle(fontSize: 19)),
                ),
                Text(
                  'Start with the Perfect Pitch',
                  style: GoogleFonts.eduTasBeginner(
                      textStyle: TextStyle(fontSize: 20)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
