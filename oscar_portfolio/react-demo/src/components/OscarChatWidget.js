import React, { useState, useRef, useEffect } from 'react';

const OscarChatWidget = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState([
    {
      role: 'assistant',
      content: "Hi! I'm Oscar's AI assistant. Ask me anything about my experience, projects, or if you'd like to collaborate!"
    }
  ]);
  const [inputValue, setInputValue] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const systemPrompt = `You are Oscar Valles, a Cloud Engineer and Full-Stack Developer. You are currently a Master's student in Computer Engineering at UTD, building cloud-native, ML-powered, and automated systems.

Key facts about you:
- Currently pursuing Master's in Computer Engineering at UTD
- Experienced in AWS, Docker, Kubernetes, CI/CD, Terraform
- Proficient in Dart/Flutter, Python, JavaScript, TypeScript, Java
- Worked with databases: DynamoDB, PostgreSQL, MongoDB, Redis
- Use tools like Git, VS Code, Postman, Jira, Confluence
- Passionate about cloud architecture and automation
- Available for collaboration and new opportunities

Your personality:
- Professional but friendly and approachable
- Enthusiastic about technology and learning
- Helpful and willing to share knowledge
- Collaborative and open to new opportunities
- Confident in your skills but humble about achievements

Always respond as Oscar would - with your personality, expertise, and enthusiasm for technology. Keep responses conversational and engaging.`;

  const sendMessage = async () => {
    if (!inputValue.trim()) return;

    const userMessage = inputValue.trim();
    setInputValue('');

    // Add user message
    setMessages(prev => [...prev, { role: 'user', content: userMessage }]);
    setIsTyping(true);

    try {
      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer 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`
        },
        body: JSON.stringify({
          model: 'gpt-3.5-turbo',
          messages: [
            { role: 'system', content: systemPrompt },
            ...messages,
            { role: 'user', content: userMessage }
          ],
          max_tokens: 500,
          temperature: 0.7
        })
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
      }

      const data = await response.json();
      const aiResponse = data.choices[0].message.content;

      setMessages(prev => [...prev, { role: 'assistant', content: aiResponse }]);
    } catch (error) {
      console.error('Error:', error);
      setMessages(prev => [...prev, { 
        role: 'assistant', 
        content: 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com'
      }]);
    } finally {
      setIsTyping(false);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      sendMessage();
    }
  };

  return (
    <>
      {/* Toggle Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="fixed bottom-5 right-5 w-15 h-15 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-full shadow-lg hover:scale-110 transition-transform z-50 flex items-center justify-center text-2xl"
      >
        💬
      </button>

      {/* Chat Widget */}
      {isOpen && (
        <div className="fixed bottom-5 right-5 w-80 h-96 bg-white rounded-xl shadow-2xl flex flex-col z-40 border border-gray-200">
          {/* Header */}
          <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-4 rounded-t-xl flex justify-between items-center">
            <div>
              <h3 className="text-lg font-semibold">Chat with Oscar</h3>
              <p className="text-sm opacity-90">AI Assistant</p>
            </div>
            <button
              onClick={() => setIsOpen(false)}
              className="text-white hover:bg-white hover:bg-opacity-20 rounded-full p-1"
            >
              ×
            </button>
          </div>

          {/* Messages */}
          <div className="flex-1 p-4 overflow-y-auto space-y-3">
            {messages.map((message, index) => (
              <div
                key={index}
                className={`max-w-[80%] p-3 rounded-lg text-sm ${
                  message.role === 'user'
                    ? 'bg-blue-500 text-white ml-auto rounded-br-sm'
                    : 'bg-gray-100 text-gray-800 rounded-bl-sm'
                }`}
              >
                {message.content}
              </div>
            ))}
            
            {isTyping && (
              <div className="flex items-center space-x-2 text-gray-500 text-sm">
                <span>Oscar is typing</span>
                <div className="flex space-x-1">
                  <div className="w-1 h-1 bg-gray-500 rounded-full animate-bounce"></div>
                  <div className="w-1 h-1 bg-gray-500 rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
                  <div className="w-1 h-1 bg-gray-500 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Input */}
          <div className="p-4 border-t border-gray-200 flex space-x-2">
            <input
              type="text"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="Ask me anything..."
              className="flex-1 p-2 border border-gray-300 rounded-full focus:outline-none focus:border-blue-500 text-sm"
            />
            <button
              onClick={sendMessage}
              className="bg-blue-500 text-white rounded-full p-2 hover:bg-blue-600 transition-colors"
            >
              ✈
            </button>
          </div>
        </div>
      )}
    </>
  );
};

export default OscarChatWidget;
