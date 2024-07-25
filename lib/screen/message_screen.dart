import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/service/chatservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitchme/controller/messageSend_controller.dart';

class MessageScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  MessageScreen({
    Key? key,
    required this.receiverEmail,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController messagecontroller = TextEditingController();

  Chatservice chatservice = Chatservice();
  //for textfield focus
  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        WidgetsBinding.instance?.addPostFrameCallback((_) => scrollDown());
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messagecontroller.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  // Send message
  Future<void> sendMessage() async {
    if (messagecontroller.text.isNotEmpty) {
      await chatservice.sendMessage(
        widget.receiverEmail,
        messagecontroller.text,
      );
      messagecontroller.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(child: _buildMessageList()),
          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = chatservice.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: chatservice.getMessage(widget.receiverEmail, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error is ${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No messages"),
          );
        }
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) {
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GestureDetector(
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: data['senderId'] == chatservice.getCurrentUser()!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: data['senderId'] == chatservice.getCurrentUser()!.uid
                  ? Colors.blue[300]
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(data['message']),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: myFocusNode,
              controller: messagecontroller,
              decoration: InputDecoration(
                hintText: "Type message",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
