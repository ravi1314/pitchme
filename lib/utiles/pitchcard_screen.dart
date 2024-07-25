import 'package:flutter/material.dart';

class PitchCard extends StatelessWidget {
  final String title;
  final String description;

  PitchCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: Color(0xFF6C757D)),
        onTap: () {
          // Navigate to detailed pitch view
        },
      ),
    );
  }
}
