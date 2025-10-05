import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Model class representing a driver profile
class DriverProfile {
  final int id;
  final String name;
  final String email;
  final String? profilePicture;
  final String? dateOfBirth;
  final String username;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.dateOfBirth,
    required this.username,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      dateOfBirth: json['dateOfBirth'],
      username: json['username'] ?? '',
      isApproved: json['isApproved'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

/// ProfileService handles all API calls related to driver profiles
class ProfileService {
  static const String baseUrl = 'http://localhost:5000/api/driver';

  static Future<DriverProfile?> getLoggedInDriverProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getInt('driverId');

      if (driverId == null) {
        throw Exception('No driver ID found in SharedPreferences');
      }

      final response = await http.get(Uri.parse('$baseUrl/$driverId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Extract the nested driver object
        if (data is Map<String, dynamic> && data['driver'] != null) {
          final driverJson = data['driver'];
          return DriverProfile.fromJson(driverJson);
        } else {
          throw Exception('Invalid response format — "driver" key missing');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }
}

