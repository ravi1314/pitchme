import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/model/messgae_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chatservice {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Send message
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    MessageModel newMessage = MessageModel(
      message: message,
      receiverId: receiverId,
      senderEmail: currentUserEmail,
      senderId: currentUserId,
      timestamp: timestamp,
    );

    // Construct chat room ID for the two users
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Add new message to the database
    await _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());

    // Check if it's the first message and store receiver's email
    DocumentSnapshot chatUserDoc =
        await _firebaseFirestore.collection('chat_users').doc(chatRoomId).get();

    if (!chatUserDoc.exists) {
      await _firebaseFirestore.collection('chat_users').doc(chatRoomId).set({
        'receiverEmail': receiverId,
        'lastMessage': message,
        'timestamp': timestamp,
      });
    } else {
      await _firebaseFirestore.collection('chat_users').doc(chatRoomId).update({
        'lastMessage': message,
        'timestamp': timestamp,
      });
    }
  }

  // Get messages
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get chat users
  Stream<QuerySnapshot> getChatUsers() {
    return _firebaseFirestore
        .collection('chat_users')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  //get all user stream except block user

  //report user

  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _firebaseAuth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };
    await _firebaseFirestore.collection('Report').add(report);
  }
  //block user

  Future<void> blockUser(String userId) async {
    final currentUser = _firebaseAuth.currentUser;
    await _firebaseFirestore
        .collection('user')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
  }
  //unblock user

  Future<void> unBlockUser(String blockedUserId) async {
    final currentUser = _firebaseAuth.currentUser;
    await _firebaseFirestore
        .collection('user')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  //get block user stream
  Stream<List<Map<String, dynamic>>> getBlockedUserStream(String userId) {
  return _firebaseFirestore
      .collection('user')
      .doc(userId)
      .collection('BlockedUsers')
      .snapshots()
      .asyncMap((snapshot) async {
    final blockedUserId = snapshot.docs.map((doc) => doc.id).toList();
    final userDocs = await Future.wait(blockedUserId
        .map((id) => _firebaseFirestore.collection('user').doc(id).get()));
    return userDocs
        .map((doc) => doc.data())
        .where((data) => data != null)
        .cast<Map<String, dynamic>>()
        .toList();
  });
}
Stream<List<Map<String, dynamic>>> getUserStreamExcludingBlocked(String userId) {
  final currentUser = _firebaseAuth.currentUser;

  return _firebaseFirestore
      .collection('user')
      .doc(userId)
      .collection('BlockedUsers')
      .snapshots()
      .asyncMap((snapshot) async {
    // Fetch blocked user IDs
    final blockedUserId = snapshot.docs.map((doc) => doc.id).toList();

    // Fetch all users
    final userSnapshot = await _firebaseFirestore.collection('user').get();

    // Filter users: Exclude current user and blocked users
    return userSnapshot.docs
        .where((doc) =>
            doc.data()['email'] != currentUser!.email && !blockedUserId.contains(doc.id))
        .map((doc) => doc.data())
        .toList();
  });
}


}
