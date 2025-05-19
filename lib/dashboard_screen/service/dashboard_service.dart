import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl;
  final http.Client client;

  DashboardService({
    required this.baseUrl,
    required this.client,
  });

  Future<DashboardData> fetchDashboardData() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/dashboard'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return DashboardData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      return DashboardData.empty();
    }
  }
}

class DashboardData {
  final String currentTime;
  final String todayEarnings;
  final String todayDateSuffix;
  final String walletBalance;
  final int pendingTasksCount;
  final OngoingTrip? ongoingTrip;
  final List<UpcomingTrip> upcomingTrips;

  DashboardData({
    required this.currentTime,
    required this.todayEarnings,
    required this.todayDateSuffix,
    required this.walletBalance,
    required this.pendingTasksCount,
    required this.ongoingTrip,
    required this.upcomingTrips,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      currentTime: json['current_time'] ?? 'N/A',
      todayEarnings: json['today_earnings']?.toString() ?? 'N/A',
      todayDateSuffix: json['today_date_suffix'] ?? 'N/A',
      walletBalance: json['wallet_balance']?.toString() ?? 'N/A',
      pendingTasksCount: json['pending_tasks_count'] ?? 0,
      ongoingTrip: json['ongoing_trip'] != null 
          ? OngoingTrip.fromJson(json['ongoing_trip']) 
          : null,
      upcomingTrips: json['upcoming_trips'] != null
          ? (json['upcoming_trips'] as List)
              .map((trip) => UpcomingTrip.fromJson(trip))
              .toList()
          : [],
    );
  }

  factory DashboardData.empty() {
    return DashboardData(
      currentTime: 'N/A',
      todayEarnings: 'N/A',
      todayDateSuffix: 'N/A',
      walletBalance: 'N/A',
      pendingTasksCount: 0,
      ongoingTrip: null,
      upcomingTrips: [],
    );
  }
}

class OngoingTrip {
  final String pickupLocation;
  final String destination;
  final String currentStatus;

  OngoingTrip({
    required this.pickupLocation,
    required this.destination,
    required this.currentStatus,
  });

  factory OngoingTrip.fromJson(Map<String, dynamic> json) {
    return OngoingTrip(
      pickupLocation: json['pickup_location'] ?? 'N/A',
      destination: json['destination'] ?? 'N/A',
      currentStatus: json['current_status'] ?? 'N/A',
    );
  }
}

class UpcomingTrip {
  final String time;
  final String destination;
  final String total;

  UpcomingTrip({
    required this.time,
    required this.destination,
    required this.total,
  });

  factory UpcomingTrip.fromJson(Map<String, dynamic> json) {
    return UpcomingTrip(
      time: json['time'] ?? 'N/A',
      destination: json['destination'] ?? 'N/A',
      total: json['total']?.toString() ?? 'N/A',
    );
  }
}