import 'package:flutter/material.dart';
import 'dart:convert';

class AIResumeAssistant {
  static final Map<String, List<String>> _knowledgeBase = {
    'experience': [
      'I have 5+ years of experience in cloud engineering and full-stack development.',
      'I specialize in AWS services including Lambda, API Gateway, DynamoDB, and EC2.',
      'I\'ve built scalable microservices architectures and serverless applications.',
      'My experience includes CI/CD pipeline development and DevOps automation.',
    ],
    'skills': [
      'Cloud Technologies: AWS, Google Cloud, Azure',
      'Programming Languages: Dart, Flutter, Python, JavaScript, TypeScript',
      'DevOps Tools: Docker, Kubernetes, Terraform, Jenkins',
      'Databases: PostgreSQL, MongoDB, DynamoDB, Redis',
      'AI/ML: TensorFlow, PyTorch, scikit-learn, data pipelines',
    ],
    'projects': [
      'Built a cloud-native e-commerce platform serving 10k+ users',
      'Developed AI-powered chatbot integration using Dialogflow',
      'Created real-time DevOps monitoring dashboard with Grafana',
      'Implemented serverless data processing pipeline for ML workflows',
    ],
    'education': [
      'Bachelor\'s degree in Computer Science',
      'AWS Certified Solutions Architect',
      'Google Cloud Professional Developer',
      'Continuous learning in AI/ML and cloud technologies',
    ],
    'contact': [
      'Email: oscar@example.com',
      'LinkedIn: linkedin.com/in/oscarvalles',
      'GitHub: github.com/ovalles2019',
      'Available for new opportunities and collaborations',
    ],
  };

  static String generateResponse(String question) {
    final lowerQuestion = question.toLowerCase();
    
    // Simple keyword matching for demo purposes
    if (lowerQuestion.contains('experience') || lowerQuestion.contains('background')) {
      return _knowledgeBase['experience']!.join('\n\n');
    } else if (lowerQuestion.contains('skill') || lowerQuestion.contains('technology')) {
      return _knowledgeBase['skills']!.join('\n\n');
    } else if (lowerQuestion.contains('project') || lowerQuestion.contains('work')) {
      return _knowledgeBase['projects']!.join('\n\n');
    } else if (lowerQuestion.contains('education') || lowerQuestion.contains('degree')) {
      return _knowledgeBase['education']!.join('\n\n');
    } else if (lowerQuestion.contains('contact') || lowerQuestion.contains('reach')) {
      return _knowledgeBase['contact']!.join('\n\n');
    } else if (lowerQuestion.contains('aws') || lowerQuestion.contains('cloud')) {
      return 'I have extensive experience with AWS services including Lambda, API Gateway, DynamoDB, EC2, S3, and CloudFormation. I\'ve designed and implemented scalable cloud architectures for various projects.';
    } else if (lowerQuestion.contains('flutter') || lowerQuestion.contains('mobile')) {
      return 'I\'m proficient in Flutter development for both mobile and web applications. I\'ve built cross-platform apps with complex state management and custom UI components.';
    } else if (lowerQuestion.contains('ai') || lowerQuestion.contains('machine learning')) {
      return 'I work with AI/ML technologies including TensorFlow, PyTorch, and scikit-learn. I\'ve built data pipelines, implemented ML models, and integrated AI services into applications.';
    } else {
      return 'I\'m a Cloud Engineer and Full-Stack Developer with expertise in AWS, Flutter, and AI infrastructure. I\'d be happy to discuss my experience in more detail. What specific area interests you?';
    }
  }

  static List<String> getSuggestedQuestions() {
    return [
      'What is your experience with AWS?',
      'Tell me about your Flutter projects',
      'What AI/ML technologies do you use?',
      'What are your strongest skills?',
      'Tell me about your education background',
      'How can I contact you?',
    ];
  }
}

class AIResumeWidget extends StatefulWidget {
  const AIResumeWidget({super.key});

  @override
  State<AIResumeWidget> createState() => _AIResumeWidgetState();
}

class _AIResumeWidgetState extends State<AIResumeWidget>
    with TickerProviderStateMixin {
  final TextEditingController _questionController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingController,
      curve: Curves.easeInOut,
    ));

    // Add welcome message
    _messages.add(ChatMessage(
      text: "Hi! I'm Oscar's AI assistant. Ask me anything about his experience, skills, or projects!",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _questionController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_questionController.text.trim().isEmpty) return;

    final question = _questionController.text.trim();
    _questionController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: question,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _typingController.forward();

    // Simulate AI thinking time
    await Future.delayed(const Duration(milliseconds: 1000));

    final response = AIResumeAssistant.generateResponse(question);

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    _typingController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Resume Assistant',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Ask me anything about Oscar\'s experience',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _TypingIndicator(animation: _typingAnimation);
                }
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // Suggested questions
          if (_messages.length == 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested questions:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AIResumeAssistant.getSuggestedQuestions().map((question) {
                      return GestureDetector(
                        onTap: () {
                          _questionController.text = question;
                          _sendMessage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            question,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: 'Ask about Oscar\'s experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isUser
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final Animation<double> animation;

  const _TypingIndicator({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final opacity = (animation.value - delay).clamp(0.0, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(opacity),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
