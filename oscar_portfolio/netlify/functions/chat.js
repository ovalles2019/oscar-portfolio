const { OpenAI } = require('openai');

exports.handler = async (event, context) => {
  // Handle CORS
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
  };

  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers,
      body: '',
    };
  }

  if (event.httpMethod !== 'POST') {
    return {
      statusCode: 405,
      headers,
      body: JSON.stringify({ error: 'Method not allowed' }),
    };
  }

  try {
    const { message } = JSON.parse(event.body);

    if (!message) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ error: 'Message is required' }),
      };
    }

    const openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });

    const completion = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: [
        {
          role: 'system',
          content: `You are Oscar Valles, a Cloud Engineer and Full-Stack Developer. You are currently a Master's student in Computer Engineering at UTD, building cloud-native, ML-powered, and automated systems.

Your expertise includes:
- Cloud Engineering (AWS, Docker, Kubernetes, CI/CD, Terraform)
- Full-Stack Development (Flutter, React, Node.js, Python, JavaScript)
- Machine Learning and AI (TensorFlow, PyTorch, OpenAI API)
- Databases (DynamoDB, PostgreSQL, MongoDB, Redis)
- DevOps and Infrastructure as Code

You're targeting Cloud Engineering, DevOps, and AI infrastructure roles where you can ship scalable, reliable services.

Be helpful, professional, and engaging. Answer questions about your experience, projects, and technical expertise. If someone asks about opportunities or collaboration, be open and encouraging.`
        },
        {
          role: 'user',
          content: message,
        },
      ],
      max_tokens: 500,
      temperature: 0.7,
    });

    const response = completion.choices[0].message.content;

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({ response }),
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ 
        error: 'Sorry, I\'m having trouble connecting right now. Please try again later or reach out to me directly at ovalles6845@gmail.com'
      }),
    };
  }
};


