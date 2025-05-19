import 'package:flutter/material.dart';
import 'splash_screen/splash_screen.dart';  // Correct relative import
import 'login_screen/login_screen.dart';  // Correct relative import
import 'dashboard_screen/dashboard_screen.dart';  // Correct relative import
import 'package:driver_frontend/dashboard_screen/service/dashboard_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is ready
  await dotenv.load(fileName: "local.env");       // Load the .env file
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Modular App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial screen
      routes: {
        '/login': (context) => LoginScreen(), // Add LoginScreen route
        '/dashboard': (context) => DashboardScreen(
          dashboardService: DashboardService(
            baseUrl: dotenv.env['API_BASE_URL'] ?? '',
            client: http.Client(),
          ),
        ),
      },
    );
  }
}
