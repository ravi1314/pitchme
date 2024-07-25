import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitchme/utiles/pitchcard_screen.dart';

class PitchListScreen extends StatefulWidget {
  const PitchListScreen({super.key});

  @override
  State<PitchListScreen> createState() => _PitchListScreenState();
}

class _PitchListScreenState extends State<PitchListScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Pitches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('pitches').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final pitches = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pitches.length,
                itemBuilder: (context, index) {
                  final pitch = pitches[index];
                  return PitchCard(
                    title: pitch['title'],
                    description: pitch['description'],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
