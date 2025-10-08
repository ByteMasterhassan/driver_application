import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReservationService {
  static const String baseUrl = 'http://localhost:5000/api';

  /// Fetch rides for the logged-in driver
  static Future<List<Map<String, dynamic>>> fetchAcceptedRides() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('driverUsername');
    final driverId = prefs.getInt('driverId');

    if (username == null || driverId == null) {
      throw Exception('Username or Driver ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/ride/all/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true && data['rides'] != null) {
        final List rides = data['rides'];

        // ✅ Filter: accepted rides, this driver only, and not dispatched yet
        final filtered = rides.where((ride) =>
          ride['accept_ride'] == true &&
          ride['driver_id'] == driverId &&
          (ride['is_exposed'] == false || ride['is_exposed'] == null) && // 🚫 skip exposed
          (ride['status'] == null || ride['status']['dispatched'] == false)
        ).toList();

        return List<Map<String, dynamic>>.from(filtered);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load rides: ${response.statusCode}');
    }
  }

  /// Change ride status (returns the flag for UI handling)
  static Future<Map<String, dynamic>> changeRideStatus(int rideId, String flag) async {
    final url = Uri.parse('$baseUrl/status/change-status/$rideId');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'flag': flag}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': data['success'] == true,
        'flag': flag,
        'rideId': rideId,
      };
    } else {
      throw Exception('Failed to change status: ${response.statusCode}');
    }
  }

    /// Expose a ride to the network
  static Future<Map<String, dynamic>> exposeRideToNetwork(int rideId) async {
    final prefs = await SharedPreferences.getInstance();
    final driverId = prefs.getInt('driverId');

    if (driverId == null) {
      throw Exception('Driver ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/network/expose');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'rideId': rideId, 'driverId': driverId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': data['success'] == true,
        'rideId': rideId,
      };
    } else {
      throw Exception('Failed to expose ride: ${response.statusCode}');
    }
  }
}
