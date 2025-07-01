import 'package:flutter/material.dart';
import 'package:driver_frontend/splash_screen/splash_screen.dart';  // Correct relative import
import 'login_screen/login_screen.dart';  // Correct relative import
import 'dashboard_screen/dashboard_screen.dart';  // Correct relative import
import 'package:driver_frontend/dashboard_screen/service/dashboard_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:driver_frontend/accounts/account.dart';
import 'package:driver_frontend/calender/calender.dart';
import 'package:driver_frontend/notification/notification.dart';
import 'package:driver_frontend/reports/report.dart';
import 'package:driver_frontend/profile/profile.dart';
import 'package:driver_frontend/history/history.dart';
import 'package:driver_frontend/quotes/quotes.dart';
import 'package:driver_frontend/dispatch/dispatch.dart';
import 'package:driver_frontend/reservation/reservation.dart';

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
        '/account': (context) => WalletAccountScreen(),
        '/calender': (context) => CalendarScreen(),
        '/notification': (context) => NotificationScreen(),
        '/report': (context) => ReportScreen(),
        '/profile': (context) => ProfileScreen(),
        '/history': (context) => HistoryScreen(),
        '/quotes': (context) => QuotesScreen(),
        '/dispatch': (context) => DispatchScreen(),
        '/reservation': (context) => ReservationScreen(),
      },
    );
  }
}
