// Oscar's AI Chat Widget - Embeddable JavaScript
// Add this script to any website to get Oscar's AI chat

(function() {
    'use strict';

    // Configuration
    const CONFIG = {
        apiKey: 'YOUR_OPENAI_API_KEY_HERE',
        apiUrl: 'https://api.openai.com/v1/chat/completions',
        systemPrompt: `You are Oscar Valles, a Cloud Engineer and Full-Stack Developer. You are currently a Master's student in Computer Engineering at UTD, building cloud-native, ML-powered, and automated systems.

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

Always respond as Oscar would - with your personality, expertise, and enthusiasm for technology. Keep responses conversational and engaging.`
    };

    // Create CSS styles
    const styles = `
        .oscar-chat-widget {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 350px;
            height: 500px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: none;
            flex-direction: column;
            z-index: 10000;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            border: 1px solid #e0e0e0;
        }

        .oscar-chat-widget.open {
            display: flex;
        }

        .oscar-chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 16px;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .oscar-chat-header h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
        }

        .oscar-chat-header .subtitle {
            font-size: 12px;
            opacity: 0.9;
        }

        .oscar-chat-close {
            background: none;
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            padding: 4px;
        }

        .oscar-chat-messages {
            flex: 1;
            padding: 16px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .oscar-message {
            max-width: 80%;
            padding: 12px 16px;
            border-radius: 18px;
            font-size: 14px;
            line-height: 1.4;
        }

        .oscar-message.user {
            background: #667eea;
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 4px;
        }

        .oscar-message.assistant {
            background: #f1f3f4;
            color: #333;
            align-self: flex-start;
            border-bottom-left-radius: 4px;
        }

        .oscar-chat-input-container {
            padding: 16px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            gap: 8px;
        }

        .oscar-chat-input {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #e0e0e0;
            border-radius: 24px;
            font-size: 14px;
            outline: none;
        }

        .oscar-chat-input:focus {
            border-color: #667eea;
        }

        .oscar-send-btn {
            background: #667eea;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .oscar-chat-toggle {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
            z-index: 10001;
            transition: transform 0.2s;
        }

        .oscar-chat-toggle:hover {
            transform: scale(1.1);
        }

        .oscar-typing-indicator {
            display: none;
            align-items: center;
            gap: 4px;
            color: #666;
            font-size: 12px;
            padding: 8px 16px;
        }

        .oscar-typing-dots {
            display: flex;
            gap: 2px;
        }

        .oscar-typing-dots span {
            width: 4px;
            height: 4px;
            background: #666;
            border-radius: 50%;
            animation: oscar-typing 1.4s infinite;
        }

        .oscar-typing-dots span:nth-child(2) {
            animation-delay: 0.2s;
        }

        .oscar-typing-dots span:nth-child(3) {
            animation-delay: 0.4s;
        }

        @keyframes oscar-typing {
            0%, 60%, 100% {
                transform: translateY(0);
            }
            30% {
                transform: translateY(-10px);
            }
        }
    `;

    // Inject styles
    const styleSheet = document.createElement('style');
    styleSheet.textContent = styles;
    document.head.appendChild(styleSheet);

    // Create widget HTML
    function createWidget() {
        const widget = document.createElement('div');
        widget.className = 'oscar-chat-widget';
        widget.innerHTML = `
            <div class="oscar-chat-header">
                <div>
                    <h3>Chat with Oscar</h3>
                    <div class="subtitle">AI Assistant</div>
                </div>
                <button class="oscar-chat-close" onclick="window.oscarChat.toggle()">×</button>
            </div>
            
            <div class="oscar-chat-messages">
                <div class="oscar-message assistant">
                    Hi! I'm Oscar's AI assistant. Ask me anything about my experience, projects, or if you'd like to collaborate!
                </div>
            </div>
            
            <div class="oscar-typing-indicator">
                <span>Oscar is typing</span>
                <div class="oscar-typing-dots">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
            
            <div class="oscar-chat-input-container">
                <input type="text" class="oscar-chat-input" placeholder="Ask me anything..." onkeypress="window.oscarChat.handleKeyPress(event)">
                <button class="oscar-send-btn" onclick="window.oscarChat.sendMessage()">✈</button>
            </div>
        `;
        return widget;
    }

    // Create toggle button
    function createToggle() {
        const toggle = document.createElement('button');
        toggle.className = 'oscar-chat-toggle';
        toggle.innerHTML = '💬';
        toggle.onclick = () => window.oscarChat.toggle();
        return toggle;
    }

    // Chat functionality
    class OscarChat {
        constructor() {
            this.messages = [
                { role: 'system', content: CONFIG.systemPrompt }
            ];
            this.widget = null;
            this.toggle = null;
            this.init();
        }

        init() {
            // Create and append elements
            this.widget = createWidget();
            this.toggle = createToggle();
            
            document.body.appendChild(this.widget);
            document.body.appendChild(this.toggle);

            // Make methods globally accessible
            window.oscarChat = this;
        }

        toggle() {
            this.widget.classList.toggle('open');
        }

        handleKeyPress(event) {
            if (event.key === 'Enter') {
                this.sendMessage();
            }
        }

        async sendMessage() {
            const input = this.widget.querySelector('.oscar-chat-input');
            const message = input.value.trim();
            
            if (!message) return;

            // Add user message
            this.addMessage('user', message);
            input.value = '';

            // Show typing indicator
            this.showTypingIndicator();

            try {
                // Add to conversation
                this.messages.push({ role: 'user', content: message });

                // Call OpenAI API
                const response = await fetch(CONFIG.apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${CONFIG.apiKey}`
                    },
                    body: JSON.stringify({
                        model: 'gpt-3.5-turbo',
                        messages: this.messages,
                        max_tokens: 500,
                        temperature: 0.7
                    })
                });

                if (!response.ok) {
                    throw new Error(`API Error: ${response.status}`);
                }

                const data = await response.json();
                const aiResponse = data.choices[0].message.content;

                // Add AI response
                this.messages.push({ role: 'assistant', content: aiResponse });

                // Hide typing and show response
                this.hideTypingIndicator();
                this.addMessage('assistant', aiResponse);

            } catch (error) {
                console.error('Oscar Chat Error:', error);
                this.hideTypingIndicator();
                this.addMessage('assistant', 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com');
            }
        }

        addMessage(sender, content) {
            const messagesContainer = this.widget.querySelector('.oscar-chat-messages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `oscar-message ${sender}`;
            messageDiv.textContent = content;
            messagesContainer.appendChild(messageDiv);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        showTypingIndicator() {
            const indicator = this.widget.querySelector('.oscar-typing-indicator');
            indicator.style.display = 'flex';
        }

        hideTypingIndicator() {
            const indicator = this.widget.querySelector('.oscar-typing-indicator');
            indicator.style.display = 'none';
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new OscarChat());
    } else {
        new OscarChat();
    }

})();

// Usage: Just include this script in any HTML page
// <script src="oscar_chat_snippet.js"></script>

