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
      MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'My App Splash Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
