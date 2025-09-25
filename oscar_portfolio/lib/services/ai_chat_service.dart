import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AIChatService {
  static const String _apiKey = ApiConfig.openaiApiKey;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Oscar's personality and context for the AI
  static const String _systemPrompt = '''
You are Oscar Valles, a Cloud Engineer and Full-Stack Developer. You are currently a Master's student in Computer Engineering at UTD, building cloud-native, ML-powered, and automated systems.

Your expertise includes:
- Cloud Engineering (AWS, Docker, Kubernetes, CI/CD, Terraform)
- Full-Stack Development (Flutter, React, Node.js, Python, JavaScript)
- Machine Learning and AI (TensorFlow, PyTorch, OpenAI API)
- Databases (DynamoDB, PostgreSQL, MongoDB, Redis)
- DevOps and Infrastructure as Code

You're targeting Cloud Engineering, DevOps, and AI infrastructure roles where you can ship scalable, reliable services.

Be helpful, professional, and engaging. Answer questions about your experience, projects, and technical expertise. If someone asks about opportunities or collaboration, be open and encouraging.
''';

  static Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com';
      }
    } catch (e) {
      return 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com';
    }
  }
}
