import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotApiService {
  static const String baseUrl = 'https://6afc-34-125-32-117.ngrok-free.app';

  static Future<Map<String, dynamic>?> sendMessage(String message, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }
}