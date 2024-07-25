import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  User? user = FirebaseAuth.instance.currentUser;
  ChatUser currentUser = ChatUser(id: '1', firstName: 'myself');
  ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');
  List<ChatMessage> allMessage = [];
  List<ChatUser> typing = [];
  final header = {'Content-Type': 'application/json'};

  getData(ChatMessage m) async {
    typing.add(bot);
    allMessage.insert(0, m);
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    try {
      await http
          .post(
              Uri.parse(
                  'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDlQzofBBvuwLO-T1llmmx6GvKQilxXnio'),
              headers: header,
              body: jsonEncode(data))
          .then((value) {
        if (value.statusCode == 200) {
          var result = jsonDecode(value.body);
          ChatMessage m1 = ChatMessage(
              text: result['candidates'][0]['content']['parts'][0]['text'],
              user: bot,
              createdAt: DateTime.now());
          allMessage.insert(0, m1);
        } else {
          print("error");
        }
      }).catchError((e) {});
      typing.remove(bot);
      setState(() {});
    } catch (e) {
      print("Error is ${e}");
    }
  }

//curl \
  // -H 'Content-Type: application/json' \
  // -d '{"contents":[{"parts":[{"text":"Explain how AI works"}]}]}' \
  //-X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=YOUR_API_KEY'//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ai ChatBot"),
        centerTitle: true,
      ),
      body: DashChat(
          typingUsers: typing,
          currentUser: currentUser,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMessage),
    );
  }
}
