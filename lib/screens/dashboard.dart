import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Hello, [name]!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 38,
              letterSpacing: -0.38,
              color: const Color(0xFF3D402E),
            ),
          ),
        ),
      ),
    );
  }
}