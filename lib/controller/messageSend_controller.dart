// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pitchme/model/messgae_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class MessagesendController extends GetxController {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static FirebaseMessaging messaging = FirebaseMessaging.instance;
// Future<void> sendMessage(String receiverId, String message, String user) async {
//   final String currentUserId = _firebaseAuth.currentUser!.uid;
//   final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
//   final Timestamp timestamp = Timestamp.now();

//   // Create a new message with the user attribute
//   MessageModel messageModel = MessageModel(
//     message: message,
//     receiverId: receiverId,
//     senderEmail: currentUserEmail,
//     senderId: currentUserId,
//     timestamp: timestamp,
//     user: user, // Include the user parameter here
//   );

//   // Construct chat room ID for the two users
//   List<String> ids = [currentUserId, receiverId];
//   ids.sort();
//   String chatRoomId = ids.join("_");

//   // Add the message to Firestore
//   await _firestore.collection("ChatRooms")
//       .doc(chatRoomId)
//       .collection("messages")
//       .add(messageModel.toMap());
// }

//   String getChatRoomId(String userId, String otherUserId) {
//     List<String> ids = [userId, otherUserId];
//     ids.sort();
//     return ids.join('_');
//   }

//   Stream<QuerySnapshot> getAllMessagesForUser(String userId) {
//     return _firestore.collectionGroup('messages')
//         .where('receiverId', isEqualTo: userId)
//         .snapshots();
//   }

//   static Future<void> getFirebaseMessagingToken() async {
//     await messaging.requestPermission();
//     await messaging.getToken().then((t) {
//       if (t != null) {
//         // Handle the token
//       }
//     });
//   }
// }
