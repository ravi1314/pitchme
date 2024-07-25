import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagepickerController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  RxList<XFile> selectdImage = <XFile>[].obs;
  final RxList<String> arrImageUrl = <String>[].obs;
  final FirebaseStorage storageRef = FirebaseStorage.instance;



  Future<void> showImagePicker()async{

  }
}
