# AI Chat Setup Instructions

## 🚀 How to Run Your Portfolio with AI Chat

### Option 1: Using the Script (Recommended)
1. Open the `run_with_api_key.sh` file
2. Replace `YOUR_ACTUAL_API_KEY` with your real OpenAI API key
3. Run the script:
   ```bash
   ./run_with_api_key.sh
   ```

### Option 2: Manual Command
```bash
flutter run -d web-server --web-port 3000 --dart-define=OPENAI_API_KEY=your_actual_api_key_here
```

### Option 3: Environment Variable
```bash
export OPENAI_API_KEY=your_actual_api_key_here
flutter run -d web-server --web-port 3000
```

## 🔧 For Production Deployment

When deploying to production (like Vercel, Netlify, etc.), you'll need to:

1. **Set Environment Variable** in your hosting platform:
   - Variable name: `OPENAI_API_KEY`
   - Value: Your actual OpenAI API key

2. **Update Build Command** to include the environment variable:
   ```bash
   flutter build web --dart-define=OPENAI_API_KEY=$OPENAI_API_KEY
   ```

## 🎯 Features

- ✅ **Floating Chat Button** - Always visible in bottom-right
- ✅ **AI Responses** - Responds as Oscar with your expertise
- ✅ **Smooth Animations** - Professional UI/UX
- ✅ **Message History** - Keeps conversation context
- ✅ **Typing Indicators** - Shows when AI is responding

## 🔒 Security

- ✅ **No API Key in Code** - Uses environment variables
- ✅ **Secure Configuration** - Prevents key exposure
- ✅ **Production Ready** - Safe for deployment

## 🎉 Ready to Go!

Your AI chat widget is now ready! Visitors can:
- Click the chat button
- Ask questions about your experience
- Get responses as if talking to you directly
- Learn about your projects and skills
- Be encouraged to reach out for opportunities
