import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: avoid_print

class BannersController extends GetxController {
  RxList<String> bannersUrl = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBannersUrls();
  }

  Future<void> fetchBannersUrls() async {
    try {
      QuerySnapshot bannersSnapshot =
          await FirebaseFirestore.instance.collection('PitchList').get();

      if (bannersSnapshot.docs.isNotEmpty) {
        bannersUrl.value = bannersSnapshot.docs
            .map((doc) => doc['image_url'] as String)
            .toList();
      }
    } catch (e) {
      print("Error : $e");
    }
  }
}
