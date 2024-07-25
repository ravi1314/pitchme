import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String receiverId;
  String senderEmail;
  String senderId;
  Timestamp timestamp;

  MessageModel({
    required this.message,
    required this.receiverId,
    required this.senderEmail,
    required this.senderId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'receiverId': receiverId,
      'senderEmail': senderEmail,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}
