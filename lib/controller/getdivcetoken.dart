import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GetDeviceTokenController extends GetxController {
  String? deviceToken;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDevicetoken();
  }

  Future<void> getDevicetoken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        deviceToken = token;
        print('tokkkkken : $deviceToken');

        ///==========  update method
        update();
      }
    } catch (e) {
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
          colorText: Colors.black);
    }
  }
}
