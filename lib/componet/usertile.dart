import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person),
      ),
      title: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 12)
              ]),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding:
              const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
          child: Center(
            child: Text(
              text,
            ),
          ),
        ),
      ),
    );
  }
}
