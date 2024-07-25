// ignore_for_file: file_names

class UserModel {
  final String uId;
  final String username;
  final String email;
  final String userImg;
  final String userDeviceToken;
  

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.userImg,
    required this.userDeviceToken,
   
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      userImg: json['userImg'],
      userDeviceToken: json['userDeviceToken'],
     
    );
  }
}
