import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatService {
  // Use Netlify function instead of direct API calls
  static const String _functionUrl = '/.netlify/functions/chat';
  
  static Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        return 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com';
      }
    } catch (e) {
      return 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com';
    }
  }
}
