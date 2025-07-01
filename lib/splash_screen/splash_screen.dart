import 'package:flutter/material.dart';
import '../login_screen/login_screen.dart';  // Correct relative import

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Simulate a delay to show splash screen for a few seconds
  _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3)); // Splash screen delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.26, 1.0],
            colors: [
              Color(0xFF121212), // dark top
              Color(0xFF1F1F1F), // slightly lighter bottom
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'My App Splash Screen',
            style: TextStyle(
              color: Color(0xFFD7B65D), // gold accent
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
