import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  static const String baseUrl = 'http://localhost:5000/api';

  /// Fetch all exposed rides
  static Future<List<Map<String, dynamic>>> fetchExposedRides() async {
    final url = Uri.parse('$baseUrl/network/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['rides'] != null) {
        return List<Map<String, dynamic>>.from(data['rides']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch exposed rides: ${response.statusCode}');
    }
  }

  /// Accept a ride from the network
  static Future<Map<String, dynamic>> acceptRide(int rideId) async {
    final prefs = await SharedPreferences.getInstance();
    final newDriverId = prefs.getInt('driverId');
    final username = prefs.getString('driverUsername');

    if (newDriverId == null || username == null) {
      throw Exception('Driver ID or username not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/network/accept');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rideId': rideId,
        'newDriverId': newDriverId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': data['success'] == true,
        'rideId': rideId,
      };
    } else {
      throw Exception('Failed to accept ride: ${response.statusCode}');
    }
  }
}
