import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl;
  final http.Client client;

  LoginService({required this.baseUrl, required this.client});

  Future<Map<String, dynamic>> loginDriver({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/driver/login");

    try {
      final response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        return {
          "success": true,
          "message": data["message"],
          "driver": data["driver"],
          "token": data["token"],
        };
      } else if (response.statusCode == 403) {
        return {
          "success": false,
          "error": data["error"] ??
              "Your account is pending approval by the admin."
        };
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "error": data["error"] ?? "Invalid credentials"
        };
      } else {
        return {
          "success": false,
          "error": data["error"] ?? "Unexpected error occurred"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "error": "❌ Error during login: $e"
      };
    }
  }
}
