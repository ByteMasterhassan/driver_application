import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuotesService {
  final String baseUrl = "http://localhost:5000/api";

  /// Fetch all rides for a driver by username
  Future<List<dynamic>> fetchRidesForDriver() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('driverUsername');

      if (username == null) {
        throw Exception('Username not found in SharedPreferences');
      }

      final response = await http.get(Uri.parse('$baseUrl/ride/all/$username'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['rides'];
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch rides');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ fetchRidesForDriver Error: $e');
      rethrow;
    }
  }

  /// Accept or reject a ride
  Future<void> updateRideStatus(int rideId, bool acceptRide) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/ride/$rideId/accept'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accept_ride': acceptRide}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update ride status: ${response.body}');
      }
    } catch (e) {
      print('❌ updateRideStatus Error: $e');
      rethrow;
    }
  }
}
