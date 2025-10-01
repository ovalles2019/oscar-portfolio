# 🚀 Oscar's AI Chat Widget - React Demo

## 🎯 **Quick Start**

### **1. Install Dependencies**
```bash
cd react-demo
npm install
```

### **2. Start Development Server**
```bash
npm start
```

### **3. Open Browser**
- Navigate to `http://localhost:3000`
- Click the chat button (bottom-right corner)
- Start chatting with Oscar!

## 🎨 **Features**

- ✅ **React Component** - Clean, reusable component
- ✅ **OpenAI Integration** - Powered by GPT-3.5-turbo
- ✅ **Oscar's Personality** - Responds as Oscar Valles
- ✅ **Real-time UI** - Typing indicators and smooth animations
- ✅ **Mobile Responsive** - Works on all devices
- ✅ **Professional Design** - Modern, polished interface

## 🔧 **Component Usage**

### **Basic Usage**
```jsx
import OscarChatWidget from './components/OscarChatWidget';

function App() {
  return (
    <div>
      <h1>My Website</h1>
      <OscarChatWidget />
    </div>
  );
}
```

### **Customization**
```jsx
// The component automatically handles:
// - OpenAI API calls
// - Message history
// - Error handling
// - Responsive design
// - Typing indicators

// No props needed - it's fully self-contained!
```

## 🎯 **Test Questions**

Try asking Oscar:
- "Hi! Tell me about yourself"
- "What projects have you worked on?"
- "What's your experience with AWS?"
- "Are you available for collaboration?"
- "What technologies do you use?"

## 🚀 **Deployment**

### **Build for Production**
```bash
npm run build
```

### **Deploy Options**
- **Vercel**: `vercel --prod`
- **Netlify**: `netlify deploy --prod --dir=build`
- **GitHub Pages**: Upload `build` folder
- **Any Static Host**: Serve `build` folder

## 🔒 **API Key Configuration**

The component uses a hardcoded API key for demo purposes. For production:

1. **Use Environment Variables**:
   ```jsx
   const API_KEY = process.env.REACT_APP_OPENAI_API_KEY;
   ```

2. **Create `.env` file**:
   ```
   REACT_APP_OPENAI_API_KEY=your_api_key_here
   ```

3. **Update Component**:
   ```jsx
   'Authorization': `Bearer ${process.env.REACT_APP_OPENAI_API_KEY}`
   ```

## 📱 **Responsive Design**

The component automatically adapts to:
- **Desktop**: Full-size chat window
- **Tablet**: Optimized layout
- **Mobile**: Touch-friendly interface
- **All Screen Sizes**: Fluid responsive design

## 🎉 **Ready to Use!**

Your React component is fully functional and ready to integrate into any React application!

**Start the demo and test Oscar's AI chat widget!** 🚀
