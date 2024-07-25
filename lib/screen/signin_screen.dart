import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pitchme/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/screen/signup_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:pitchme/controller/signin_controller.dart';
import 'package:pitchme/controller/googlesigin_controller.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final SignInController signinController = Get.put(SignInController());
  final GoogleSigninController googleSigninController =
      Get.put(GoogleSigninController());

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    print("Build Called Again");
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
              ),
              SizedBox(
                height: 250,
                width: 230,
                child: RiveAnimation.asset(
                  "asset/image/login_teddy.riv",
                  fit: BoxFit.fitHeight,
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,

                      /// from rive, you can see it in rive editor
                      "Login Machine",
                    );
                    if (controller == null) return;

                    artboard.addController(controller!);
                    isChecking = controller?.findInput("isChecking");
                    numLook = controller?.findInput("numLook");
                    isHandsUp = controller?.findInput("isHandsUp");
                    trigSuccess = controller?.findInput("trigSuccess");
                    trigFail = controller?.findInput("trigFail");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 300,
                  width: 430,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        color: Colors.white,
                        child: TextField(
                          focusNode: emailFocusNode,
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            labelText: "Email",
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {
                            numLook?.change(value.length.toDouble());
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 10,
                        color: Colors.white,
                        child: TextField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: "Password",
                          ),
                          obscureText: true,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              "Forget Password",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 130,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SignUpScreen());
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      SignInButton(Buttons.google, onPressed: () {
                        googleSigninController.signinWithGoogle();
                      }),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 100,
                        height: 44,
                        child: GestureDetector(
                          onTap: () async {
                            emailFocusNode.unfocus();
                            passwordFocusNode.unfocus();

                            final email = emailController.text;
                            final password = passwordController.text;

                            if (mounted) Navigator.pop(context);

                            if (email != null && password != null) {
                              trigSuccess?.change(true);
                              final String email = emailController.text.trim();
                              final String password =
                                  passwordController.text.trim();
                              Get.offAll(() => HomeScreen());
                              if (email.isEmpty || password.isEmpty) {
                                Get.snackbar("Error", "Please Fill all detail",
                                    snackPosition: SnackPosition.TOP);
                              } else {
                                UserCredential? usercredential =
                                    await signinController.signInMethod(
                                        email, password);
                                Get.snackbar("Thank you", "You are now Login");
                              }
                            } else {
                              trigFail?.change(true);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                                child: const Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
