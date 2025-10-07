import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DispatchService {
  static const String baseUrl = 'http://localhost:5000/api';

  /// Fetch rides that are dispatched and not completed
  static Future<List<Map<String, dynamic>>> fetchDispatchedRides() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('driverUsername');
    final driverId = prefs.getInt('driverId');

    if (username == null || driverId == null) {
      throw Exception('Username or Driver ID not found in SharedPreferences');
    }

    // 1️⃣ Get all rides for the current driver
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
    final List<Map<String, dynamic>> dispatchedRides = [];

    // 2️⃣ Loop each ride and fetch RideStatus separately
    for (final ride in rides) {
      final int? rideId = ride['id'];
      final int? rideDriverId = ride['driver_id'];
      final bool? accepted = ride['accept_ride'];

      if (rideId == null || rideDriverId != driverId || accepted != true) {
        continue;
      }

      // Get RideStatus for this ride
      final statusUrl = Uri.parse('$baseUrl/status/get-status/$rideId');
      final statusResponse = await http.get(statusUrl);

      if (statusResponse.statusCode == 200) {
        final statusData = jsonDecode(statusResponse.body);
        final rideStatus = statusData['data'];

        if (rideStatus != null &&
            rideStatus['dispatched'] == true &&
            rideStatus['completed'] == false) {
          // Merge Ride + RideStatus
          ride['RideStatus'] = rideStatus;
          dispatchedRides.add(Map<String, dynamic>.from(ride));
        }
      }
    }

    return dispatchedRides;
  }

  /// Change ride status (PATCH)
  static Future<bool> changeRideStatus(int rideId, String flag) async {
    final url = Uri.parse('$baseUrl/status/change-status/$rideId');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'flag': flag}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else if (response.statusCode == 404) {
      throw Exception('Ride not found for ID: $rideId');
    } else {
      throw Exception('Failed to change status: ${response.statusCode}');
    }
  }
}
