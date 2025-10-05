import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  final String baseUrl;
  final http.Client client;

  DashboardService({
    required this.baseUrl,
    required this.client,
  });

  // Get driver ID from SharedPreferences
  Future<int?> getDriverId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('driverId');
    } catch (e) {
      print('Error getting driver ID: $e');
      return null;
    }
  }

  // Fetch dashboard data
  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final driverId = await getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID not found in SharedPreferences');
      }

      // Explicitly use localhost:5000 as base URL
      final String explicitBaseUrl = 'http://localhost:5000';
      final url = Uri.parse('$explicitBaseUrl/api/driver/$driverId');
      
      print('Fetching dashboard data from: $url');

      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if response is valid JSON
        try {
          final data = json.decode(response.body);
          
          if (data['success'] == true) {
            return {
              'totalEarnings': data['totalEarnings'] ?? 0,
              'weeklyEarnings': data['weeklyEarnings'] ?? 0,
              'dailyEarnings': data['dailyEarnings'] ?? 0,
            };
          } else {
            throw Exception('API returned success: false - ${data['message'] ?? 'No message'}');
          }
        } catch (e) {
          throw Exception('Invalid JSON response: $e. Response body: ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found (404). Check if the API URL is correct.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error (${response.statusCode}). Please try again later.');
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
      rethrow;
    }
  }
}