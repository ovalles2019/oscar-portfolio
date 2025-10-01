#!/bin/bash

echo "🚀 Deploying Oscar's Portfolio to Netlify"
echo "=========================================="
echo ""

# Build the project
echo "📦 Building Flutter web app..."
flutter build web --release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📁 Build output: build/web/"
    echo ""
    echo "🌐 Deploy Options:"
    echo ""
    echo "1️⃣  NETLIFY CLI (Recommended)"
    echo "   npm install -g netlify-cli"
    echo "   netlify deploy --prod --dir=build/web"
    echo ""
    echo "2️⃣  NETLIFY WEB INTERFACE"
    echo "   Go to: https://app.netlify.com"
    echo "   Drag & Drop: build/web folder"
    echo ""
    echo "3️⃣  GITHUB INTEGRATION"
    echo "   Connect your GitHub repo to Netlify"
    echo "   Auto-deploy on every push"
    echo ""
    echo "🔑 Don't forget to set OPENAI_API_KEY environment variable!"
    echo "   Your API key: YOUR_OPENAI_API_KEY_HERE"
    echo ""
    echo "🎉 Your portfolio is ready to deploy!"
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi

