// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:pitchme/service/chatservice.dart';
// import 'package:pitchme/screen/message_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatUserScreen extends StatelessWidget {
//   ChatUserScreen({super.key});
//   final Chatservice _chatservice = Chatservice();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Users'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: _chatservice.getChatUsers(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             print("Error is ${snapshot.error}");
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("No users found"),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final doc = snapshot.data!.docs[index];
//               final data = doc.data() as Map<String, dynamic>;

//               return GestureDetector(
//                 onTap: () {
//                   Get.to(() => MessageScreen(
//                       receiverEmail: data['receiverEmail'],
//                       receiverId: data['receiverId'].toString()));
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.all(8),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(blurRadius: 12, color: Colors.grey),
//                       ]),
//                   child: Row(
//                     children: [
//                       const CircleAvatar(
//                         child: Icon(Icons.person),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(data['receiverEmail'] ?? 'No Email'),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
