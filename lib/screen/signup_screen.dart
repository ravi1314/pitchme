import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:pitchme/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/screen/signin_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:pitchme/controller/signup_controller.dart';
import 'package:pitchme/controller/googlesigin_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  final GoogleSigninController googleSigninController =
      Get.put(GoogleSigninController());

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  FocusNode usernameFocusNode = FocusNode();
  TextEditingController usernameController = TextEditingController();

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
    usernameController.addListener(usernameFocus);
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

  void usernameFocus() {
    isChecking?.change(usernameFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            SizedBox(
              height: 250,
              width: 250,
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
                height: 390,
                width: 450,
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
                        focusNode: usernameFocusNode,
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          labelText: "Username",
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {},
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          labelText: "Password",
                        ),
                        obscureText: true,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
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
                              Get.to(() => SigninScreen());
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SignInButton(Buttons.google, onPressed: () {
                      googleSigninController.signinWithGoogle();
                    }),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 100,
                      height: 44,
                      child: GestureDetector(
                        onTap: () async {
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();

                          final email = emailController.text;
                          final password = passwordController.text;

                          await Future.delayed(
                            const Duration(milliseconds: 2000),
                          );
                          if (mounted) Navigator.pop(context);

                          if (email != null && password != null) {
                            trigSuccess?.change(true);
                          } else {
                            trigFail?.change(true);
                          }
                          String username = usernameController.text.trim();
                          String useremail = emailController.text.trim();
                          String userpassword = passwordController.text.trim();
                          String userDeviceToken = '';

                          ///==============is nul
                          ///
                          if (username.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            Get.snackbar('Error', 'Please Enter all detail',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.grey,
                                colorText: Colors.black);
                          } else {
                            UserCredential? userCredential =
                                await signUpController.signUpMethod(username,
                                    useremail, userpassword, userDeviceToken);
                            Get.to(() => HomeScreen());

                            if (userCredential != null) {
                              Get.snackbar('Verification email',
                                  'Please Check Your email',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.grey,
                                  colorText: Colors.black);
                              FirebaseAuth.instance.signOut();
                              Get.offAll(() => const SigninScreen());
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                              child: Text(
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
    );
  }
}
