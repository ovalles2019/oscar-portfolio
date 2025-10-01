#!/bin/bash

echo "🚀 Oscar's Portfolio Full Deployment Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Step 1: Build Flutter Web App
print_status "Building Flutter web app..."
flutter build web --release

if [ $? -eq 0 ]; then
    print_success "Flutter build completed!"
else
    print_error "Flutter build failed!"
    exit 1
fi

echo ""
print_status "Deployment Options:"
echo ""
echo "🌐 FRONTEND (Portfolio Website):"
echo "1️⃣  NETLIFY (Recommended)"
echo "   - Go to: https://app.netlify.com"
echo "   - Drag & Drop: build/web folder"
echo "   - Or connect GitHub repo for auto-deploy"
echo ""
echo "2️⃣  VERCEL"
echo "   - Install: npm i -g vercel"
echo "   - Run: vercel --prod"
echo ""
echo "3️⃣  FIREBASE"
echo "   - Install: npm install -g firebase-tools"
echo "   - Run: firebase init hosting && firebase deploy"
echo ""

echo "🔧 BACKEND (Chat API):"
echo "1️⃣  VERCEL (Recommended for Node.js)"
echo "   - Install: npm i -g vercel"
echo "   - Run: cd chat-backend && vercel --prod"
echo "   - Set environment variable: OPENAI_API_KEY"
echo ""
echo "2️⃣  RAILWAY"
echo "   - Go to: https://railway.app"
echo "   - Connect GitHub repo"
echo "   - Deploy chat-backend folder"
echo ""
echo "3️⃣  HEROKU"
echo "   - Install: npm i -g heroku"
echo "   - Run: cd chat-backend && heroku create && git push heroku main"
echo ""

echo "🔑 IMPORTANT: Environment Variables"
echo "Set OPENAI_API_KEY in your backend deployment platform:"
echo "YOUR_OPENAI_API_KEY_HERE"
echo ""

echo "📝 AFTER DEPLOYMENT:"
echo "1. Update chat widget API URL to your backend URL"
echo "2. Test the chat functionality"
echo "3. Update your portfolio with the new backend URL"
echo ""

print_success "Ready to deploy! Choose your preferred platform above."
