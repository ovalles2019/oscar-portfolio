import React from 'react';
import OscarChatWidget from './components/OscarChatWidget';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>🚀 Oscar's AI Chat Widget Demo</h1>
        <p>Click the chat button in the bottom-right corner to start chatting with Oscar!</p>
        
        <div className="demo-content">
          <h2>About This Demo</h2>
          <p>This is a demonstration of Oscar's AI Chat Widget built as a React component.</p>
          
          <h3>Features:</h3>
          <ul>
            <li>✅ React Component Architecture</li>
            <li>✅ OpenAI GPT Integration</li>
            <li>✅ Oscar's Personality & Expertise</li>
            <li>✅ Real-time Typing Indicators</li>
            <li>✅ Mobile Responsive Design</li>
            <li>✅ Professional UI/UX</li>
          </ul>
          
          <h3>Try These Questions:</h3>
          <ul>
            <li>"Hi! Tell me about yourself"</li>
            <li>"What projects have you worked on?"</li>
            <li>"What's your experience with AWS?"</li>
            <li>"Are you available for collaboration?"</li>
          </ul>
        </div>
      </header>
      
      {/* Oscar's AI Chat Widget */}
      <OscarChatWidget />
    </div>
  );
}

export default App;
