import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String baseUrl = 'http://localhost:5000/api';

  /// Fetch rides that are completed (history)
  static Future<List<Map<String, dynamic>>> fetchCompletedRides() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('driverUsername');
    final driverId = prefs.getInt('driverId');

    if (username == null || driverId == null) {
      throw Exception('Username or Driver ID not found in SharedPreferences');
    }

    // 1️⃣ Get all rides for the driver
    final url = Uri.parse('$baseUrl/ride/all/$username');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load rides: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data['success'] != true || data['rides'] == null) {
      return [];
    }

    final List rides = data['rides'];
    final List<Map<String, dynamic>> completedRides = [];

    // 2️⃣ Fetch RideStatus for each ride and filter completed ones
    for (final ride in rides) {
      final int? rideId = ride['id'];
      final int? rideDriverId = ride['driver_id'];
      final bool? accepted = ride['accept_ride'];

      if (rideId == null || rideDriverId != driverId || accepted != true) {
        continue;
      }

      final statusUrl = Uri.parse('$baseUrl/status/get-status/$rideId');
      final statusResponse = await http.get(statusUrl);

      if (statusResponse.statusCode == 200) {
        final statusData = jsonDecode(statusResponse.body);
        final rideStatus = statusData['data'];

        if (rideStatus != null && rideStatus['completed'] == true) {
          // Merge Ride + RideStatus
          ride['RideStatus'] = rideStatus;
          completedRides.add(Map<String, dynamic>.from(ride));
        }
      }
    }

    return completedRides;
  }
}
