#!/bin/bash

# Set the OpenAI API key as environment variable
# Replace with your actual API key
export OPENAI_API_KEY='YOUR_OPENAI_API_KEY_HERE'

echo "🚀 Starting Oscar's Portfolio with AI Chat..."
echo "📍 OpenAI API Key: Set ✅"
echo "🌐 Opening at: http://localhost:3000"
echo ""
echo "💬 Test the AI chat by clicking the floating chat button!"
echo ""

# Run Flutter web app
flutter run -d web-server --web-port 3000
