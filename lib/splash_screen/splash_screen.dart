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

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay
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
              Color(0xFF1F1F1F), // lighter dark bottom
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // App icon (driver/taxi)
              Icon(
                Icons.local_taxi_rounded,
                size: 100,
                color: Color(0xFFD7B65D),
              ),
              SizedBox(height: 20),

              // App title
              Text(
                'Driver App',
                style: TextStyle(
                  color: Color(0xFFD7B65D),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 8),

              // Tagline
              Text(
                'Powered for Drivers',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 40),

              // Progress indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD7B65D)),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
