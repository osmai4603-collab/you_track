import 'package:flutter/material.dart';

class UserIconWidget extends StatelessWidget {
  final String userKey;
  const UserIconWidget({super.key, required this.userKey});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Color(0xFF4CAF50),
      child: Text(
        userKey,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
