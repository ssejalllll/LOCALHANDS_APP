import 'package:flutter/material.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/image.png", // your background image
              fit: BoxFit.cover,   // cover entire screen
            ),
          ),

          // Foreground content
          Center(
            child: Text(
              "Login Screen",
              style: TextStyle(
                fontSize: 28,               // slightly larger
                fontWeight: FontWeight.bold,
                color: Colors.white,        // visible on background
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black45,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
