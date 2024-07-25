import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: collection_methods_unrelated_type

// ignore_for_file: unused_element

// ignore_for_file: avoid_print

// ignore_for_file: prefer_const_constructors

// ignore_for_file: unused_local_variable

// ignore_for_file: unused_field

class AddProductsImageController extends GetxController {
  ///create variable for pick image
  ///
  ///
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  //file
  RxList<XFile> selectedImage = <XFile>[].obs;

  final RxList<String> arrimageUrl = <String>[].obs;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagesPickerDialog() async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt <= 32) {
      print("Not matched");
      status = await Permission.storage.request();
    } else {
      status = await Permission.mediaLibrary.request();
    }
    /////////
    if (status == PermissionStatus.granted) {
      Get.defaultDialog(
          title: "Select Image",
          middleText: 'Gallery or Camera',
          actions: [
            ElevatedButton(
                onPressed: () {
                  selectImage('camera');
                },
                child: Text("Camera")),
            ElevatedButton(
                onPressed: () {
                  selectImage('gallery');
                },
                child: Text("Gallery")),
          ]);
    }
    if (status == PermissionStatus.denied) {
      Get.snackbar("Allow", "Pleas allow permission for further usage",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(microseconds: 5),
          colorText: Colors.black);
      openAppSettings();
    }
    if (status == PermissionStatus.permanentlyDenied) {
      Get.snackbar("Not Allow", 'For usage',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          duration: Duration(microseconds: 5));
      openAppSettings();
    }

    /// for select image
    ///
  }

  Future<void> selectImage(String type) async {
    List<XFile> image = [];
    if (type == 'gallery') {
      try {
        image = await _imagePicker.pickMultiImage(imageQuality: 80);
        update();
      } catch (e) {
        print("Error is $e");
      }
    } else {
      final img = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 80);

      if (img != null) {
        image.add(img);
        update();
      }
    }
    if (image.isNotEmpty) {
      selectedImage.addAll(image);
      update();
      print(selectedImage.length);
    }
  }

  //selected image
  void removeImages(int index) {
    selectedImage.removeAt(index);
    update();
  }
  //upload image in firebase

  Future<void> uploadFunction(List<XFile> _images) async {
    arrimageUrl.clear();
    for (int i = 0; i < _images.length; i++) {
      dynamic imageUrl = await uploadFile(_images[i]);
      arrimageUrl.add(imageUrl.toString());
    }
    update();
  }
  //upload file

  Future<String> uploadFile(XFile _image) async {
    TaskSnapshot reference = await storageRef
        .ref()
        .child('image_url')
        .child(_image.name + DateTime.now().toString())
        .putFile(File(_image.path));

    return await reference.ref.getDownloadURL();
  }

  Future<void> pickAndUploadPDF() async {
    // Pick a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path!;

      // Upload to Firebase Storage
      User? user = _auth.currentUser;
      String userId = user?.uid ?? '';
      String storagePath = 'pdfs/$userId/${file.name}';
      File pdfFile = File(filePath);

      try {
        await _storage.ref(storagePath).putFile(pdfFile);

        // Get the download URL
        String downloadURL = await _storage.ref(storagePath).getDownloadURL();

        // Store the URL in Firestore

        // Show a success message
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('PDF uploaded successfully!')),
        );
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Failed to upload PDF: $e')),
        );
      }
    }
  }
}
