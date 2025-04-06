import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://192.168.240.220";
  static const Duration _timeout = Duration(seconds: 2);

  static Future<void> startTimer(int seconds) async {
    try {
      int milliseconds = seconds * 1000;
      await http
          .get(Uri.parse("$_baseUrl/start?time=$milliseconds"))
          .timeout(_timeout);
    } catch (e) {
      print("Error starting timer: $e");
    }
  }

  static Future<void> stopTimer() async {
    try {
      await http
          .get(Uri.parse("$_baseUrl/stop")) // Removed query parameter
          .timeout(_timeout);
    } catch (e) {
      print("Error stopping timer: $e");
    }
  }

  static Future<void> resetTimer() async {
    try {
      await http
          .get(Uri.parse("$_baseUrl/reset")) // Removed query parameter
          .timeout(_timeout);
    } catch (e) {
      print("Error resetting timer: $e");
    }
  }
}
