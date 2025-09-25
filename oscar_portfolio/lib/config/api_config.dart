class ApiConfig {
  // Using environment variable for security
  // Set OPENAI_API_KEY environment variable or use --dart-define=OPENAI_API_KEY=your_key_here
  static const String openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: 'YOUR_OPENAI_API_KEY_HERE', // Replace with your actual API key
  );
}
