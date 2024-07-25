import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class MediaController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> selectedMedia = [];
  List<String> arrMediaUrl = [];

  // Select image or video
  Future<void> selectMedia(String type, String mediaType) async {
    List<XFile> media = [];
    try {
      if (type == 'gallery') {
        if (mediaType == 'video') {
          final pickedVideo = await _imagePicker.pickVideo(source: ImageSource.gallery);
          if (pickedVideo != null) {
            media.add(pickedVideo);
          }
        } else {
          media = await _imagePicker.pickMultiImage(imageQuality: 80);
        }
      } else {
        final pickedMedia = await (mediaType == 'video'
            ? _imagePicker.pickVideo(source: ImageSource.camera)
            : _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80));
        if (pickedMedia != null) {
          media.add(pickedMedia);
        }
      }

      if (media.isNotEmpty) {
        selectedMedia.addAll(media);
        update();
        print(selectedMedia.length);
      }
    } catch (e) {
      print("Error is $e");
    }
  }

  // Remove selected media
  void removeMedia(int index) {
    selectedMedia.removeAt(index);
    update();
  }

  // Upload media to Firebase
  Future<void> uploadFunction(List<XFile> _media) async {
    arrMediaUrl.clear();
    for (int i = 0; i < _media.length; i++) {
      dynamic mediaUrl = await uploadFile(_media[i]);
      arrMediaUrl.add(mediaUrl.toString());
    }
    update();
  }

  // Upload file
  Future<String> uploadFile(XFile _media) async {
    TaskSnapshot reference = await FirebaseStorage.instance
        .ref()
        .child('media_url')
        .child(_media.name + DateTime.now().toString())
        .putFile(File(_media.path));

    return await reference.ref.getDownloadURL();
  }
}
