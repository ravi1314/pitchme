import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pitchme/screen/signin_screen.dart';
import 'package:pitchme/screen/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pitchme/controller/signup_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SignUpController signUpController = SignUpController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notification_add,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Notification",
                            style: GoogleFonts.play(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.message,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Message",
                            style: GoogleFonts.play(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 330,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Profile",
                            style: GoogleFonts.play(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 370,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.privacy_tip,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Privacy",
                            style: GoogleFonts.play(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Profile",
                            style: GoogleFonts.play(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 360,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.group_add,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "My Network",
                            style: GoogleFonts.play(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(10, 10),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 8,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.batch_prediction_sharp,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Your Pitch",
                            style: GoogleFonts.play(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print("signout");
                      await signUpController.signOut();
                      Get.to(() => const SigninScreen());
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(10, 10),
                              blurRadius: 8,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 8,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Logout",
                              style: GoogleFonts.play(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SignUpScreen());
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(10, 10),
                              blurRadius: 8,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 8,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Login",
                              style: GoogleFonts.play(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
