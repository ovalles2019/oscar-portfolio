const express = require('express');
const cors = require('cors');
const OpenAI = require('openai');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3001;

// Initialize OpenAI
console.log('API Key length:', process.env.OPENAI_API_KEY ? process.env.OPENAI_API_KEY.length : 'undefined');
console.log('API Key starts with:', process.env.OPENAI_API_KEY ? process.env.OPENAI_API_KEY.substring(0, 20) + '...' : 'undefined');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Chat backend is running' });
});

// Chat endpoint
app.post('/api/chat', async (req, res) => {
  try {
    const { messages } = req.body;

    if (!messages || !Array.isArray(messages)) {
      return res.status(400).json({ 
        success: false, 
        message: 'Messages array is required' 
      });
    }

    // Add system message to provide Oscar's personality
    const systemMessage = {
      role: 'system',
      content: `You are Oscar Valles, a passionate software engineer and AWS Solutions Architect with 5+ years of experience. You're enthusiastic about cloud technologies, DevOps, and building scalable solutions. You're friendly, professional, and always eager to help with technical questions. Keep responses concise but informative, and maintain a conversational tone.`
    };

    const chatMessages = [systemMessage, ...messages];

    const completion = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: chatMessages,
      max_tokens: 500,
      temperature: 0.7,
    });

    const response = completion.choices[0].message.content;

    res.json({
      success: true,
      message: response
    });

  } catch (error) {
    console.error('OpenAI API Error:', error);
    console.error('Error details:', {
      message: error.message,
      status: error.status,
      code: error.code,
      type: error.type
    });
    
    res.status(500).json({
      success: false,
      message: 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com',
      error: error.message
    });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Chat backend server running on port ${port}`);
  console.log(`Health check: http://localhost:${port}/api/health`);
});