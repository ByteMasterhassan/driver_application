import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  final String baseUrl = "http://localhost:5000/api";

  Future<Map<String, dynamic>> fetchDriverAccountData([String? driverId]) async {
    try {
      // 🔹 Fetch driverId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final int? driverId = prefs.getInt('driverId');

      if (driverId == null) {
        throw Exception("Driver ID not found in SharedPreferences");
      }

      final response = await http.get(Uri.parse('$baseUrl/driver/$driverId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final totalEarnings = (data['totalEarnings'] ?? 0).toDouble();

          // 🔹 Parse ride dates into DateTime list
          final List<dynamic> rideDates = data['rideDates'] ?? [];
          List<DateTime> parsedDates = rideDates
              .map<DateTime>((d) => DateTime.parse(d['createdAt']))
              .toList();

          // 🔹 Generate chart data (grouped by weekday for current month)
          final now = DateTime.now();
          final currentMonth = now.month;
          final currentYear = now.year;

          // Initialize weekday map (Mon–Sun)
          Map<String, int> weeklyData = {
            'Mon': 0,
            'Tue': 0,
            'Wed': 0,
            'Thu': 0,
            'Fri': 0,
            'Sat': 0,
            'Sun': 0,
          };

          for (final date in parsedDates) {
            if (date.month == currentMonth && date.year == currentYear) {
              final weekday = DateFormat('E').format(date); // Mon, Tue...
              if (weeklyData.containsKey(weekday)) {
                weeklyData[weekday] = weeklyData[weekday]! + 1;
              }
            }
          }

          return {
            'totalEarnings': totalEarnings,
            'weeklyChartData': weeklyData,
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch driver data');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ AccountService Error: $e');
      rethrow;
    }
  }
}
