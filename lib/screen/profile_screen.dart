import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pitchme/controller/prfile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();
  final ProfileController _profileController = Get.put(ProfileController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pitcherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    await _profileController.loadUserProfile();
    setState(() {
      usernameController.text = _profileController.username.value;
      emailController.text = _profileController.email.value;
      pitcherController.text = _profileController.pitcher.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Pitcher Profile",
                  style: GoogleFonts.play(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ]),
            ),
            const SizedBox(height: 50),
            Center(
              child: Container(
                height: 340,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              backgroundImage: _profileController
                                      .isProfilePicPathSet.value
                                  ? FileImage(File(
                                      _profileController.profilePicPath.value))
                                  : const AssetImage('asset/image/bg.png')
                                      as ImageProvider,
                              radius: 20,
                            );
                          }),
                          Positioned(
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                print("Camera is clicked");
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => bottomSheet(context),
                                );
                              },
                              child: const Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: GoogleFonts.play(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.play(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: pitcherController,
                        decoration: InputDecoration(
                            labelText: 'Pitcher',
                            labelStyle: GoogleFonts.play(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide())),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _profileController.saveUserProfile(
                            usernameController.text,
                            emailController.text,
                            pitcherController.text,
                          );
                          Get.snackbar("Thank you", "your profile is submitted",
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.white,
                              backgroundColor: Colors.black);
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                          child: Center(
                            child: Text(
                              "Save Data",
                              style: GoogleFonts.play(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
        ),
        width: double.infinity,
        height: size.height * 0.3,
        child: Column(
          children: [
            Text(
              'Choose Profile photo',
              style: GoogleFonts.play(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    takePhoto(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      const Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        "Camera",
                        style: GoogleFonts.play(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                InkWell(
                  onTap: () {
                    takePhoto(ImageSource.gallery);
                  },
                  child: Column(
                    children: [
                      const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        "Gallery",
                        style: GoogleFonts.play(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileController.setProfileImagePath(pickedFile.path);
      });
    }
  }
}
