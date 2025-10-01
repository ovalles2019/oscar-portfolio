#!/bin/bash

echo "🚀 Oscar's Portfolio Deployment Script"
echo "======================================"
echo ""

# Build the project
echo "📦 Building Flutter web app..."
flutter build web --release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📁 Build output: build/web/"
    echo ""
    echo "🌐 Deployment Options:"
    echo ""
    echo "1️⃣  VERCEL (Recommended - Fastest)"
    echo "   npm i -g vercel"
    echo "   vercel --prod"
    echo ""
    echo "2️⃣  NETLIFY"
    echo "   npx netlify-cli deploy --prod --dir=build/web"
    echo ""
    echo "3️⃣  FIREBASE"
    echo "   npm install -g firebase-tools"
    echo "   firebase init hosting"
    echo "   firebase deploy"
    echo ""
    echo "4️⃣  GITHUB PAGES"
    echo "   Push build/web contents to gh-pages branch"
    echo ""
    echo "🔑 Don't forget to set OPENAI_API_KEY environment variable!"
    echo "   Set your API key in the deployment platform's environment variables"
    echo ""
    echo "🎉 Your portfolio is ready to deploy!"
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
