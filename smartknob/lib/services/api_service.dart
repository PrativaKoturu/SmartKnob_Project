import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl =
      "http://192.168.1.4:8080"; // Use your actual IP

  static Future<void> setTimer(int time) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/set-timer"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"time": time}),
      );
      if (response.statusCode == 200) {
        print("Timer set successfully!");
      } else {
        print("Failed to set timer.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
