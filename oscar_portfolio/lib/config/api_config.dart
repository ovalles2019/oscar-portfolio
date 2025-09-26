class ApiConfig {
  // Using environment variable for security
  // Set OPENAI_API_KEY environment variable or use --dart-define=OPENAI_API_KEY=your_key_here
  static const String openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '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', // Temporary for testing
  );
}
