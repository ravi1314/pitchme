import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var pitcher = ''.obs;
  var profilePicPath = ''.obs;
  var isProfilePicPathSet = false.obs;

  Future<void> loadUserProfile() async {
    // Load user profile data from persistent storage (Firestore or SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    email.value = prefs.getString('email') ?? '';
    pitcher.value = prefs.getString('pitcher') ?? '';
    profilePicPath.value = prefs.getString('profilePicPath') ?? '';
    isProfilePicPathSet.value = profilePicPath.value.isNotEmpty;
  }

  void saveUserProfile(String username, String email, String pitcher) async {
    // Save user profile data to persistent storage (Firestore or SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('pitcher', pitcher);
  }

  void setProfileImagePath(String path) async {
    profilePicPath.value = path;
    isProfilePicPathSet.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePicPath', path);
  }
}
