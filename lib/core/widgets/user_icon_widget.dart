import 'package:flutter/material.dart';

class UserIconWidget extends StatelessWidget {
  const UserIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 14,
      backgroundColor: Color(0xFF4CAF50),
      child: Text(
        'AD',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
