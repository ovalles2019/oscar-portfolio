import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodePlaygroundWidget extends StatefulWidget {
  const CodePlaygroundWidget({super.key});

  @override
  State<CodePlaygroundWidget> createState() => _CodePlaygroundWidgetState();
}

class _CodePlaygroundWidgetState extends State<CodePlaygroundWidget>
    with TickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _runAnimationController;
  late Animation<double> _runAnimation;
  String _output = '';
  bool _isRunning = false;
  int _selectedExample = 0;

  final List<CodeExample> _examples = [
    CodeExample(
      title: 'Flutter Widget',
      description: 'Create a simple Flutter widget',
      code: '''class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Hello, Flutter!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}''',
    ),
    CodeExample(
      title: 'State Management',
      description: 'Counter app with StatefulWidget',
      code: '''class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: \$_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: Text('Increment'),
        ),
      ],
    );
  }
}''',
    ),
    CodeExample(
      title: 'API Call',
      description: 'HTTP request with async/await',
      code: '''import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchUserData() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/user'),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    print('Error: \$e');
    return {};
  }
}''',
    ),
    CodeExample(
      title: 'Animation',
      description: 'Simple animation with AnimationController',
      code: '''class AnimatedWidget extends StatefulWidget {
  @override
  _AnimatedWidgetState createState() => _AnimatedWidgetState();
}

class _AnimatedWidgetState extends State<AnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        );
      },
    );
  }
}''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _runAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _runAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _runAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadExample(0);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _runAnimationController.dispose();
    super.dispose();
  }

  void _loadExample(int index) {
    setState(() {
      _selectedExample = index;
      _codeController.text = _examples[index].code;
      _output = '';
    });
  }

  void _runCode() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _output = 'Running code...';
    });

    _runAnimationController.forward().then((_) {
      _runAnimationController.reverse();
    });

    // Simulate code execution
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isRunning = false;
      _output = _generateOutput();
    });
  }

  String _generateOutput() {
    switch (_selectedExample) {
      case 0:
        return '✓ Widget created successfully!\n✓ Renders "Hello, Flutter!" text\n✓ Styled with 24px bold font';
      case 1:
        return '✓ StatefulWidget initialized\n✓ Counter state: 0\n✓ Increment button ready\n✓ State updates working';
      case 2:
        return '✓ HTTP client initialized\n✓ API endpoint: https://api.example.com/user\n✓ JSON parsing ready\n✓ Error handling implemented';
      case 3:
        return '✓ AnimationController created\n✓ Animation duration: 2 seconds\n✓ Opacity animation: 0.0 → 1.0\n✓ Reverse animation enabled';
      default:
        return '✓ Code executed successfully!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
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
                    Icons.code,
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
                        'Live Code Playground',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Try Flutter/Dart code snippets',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _runAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _runAnimation.value,
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? null : _runCode,
                        icon: _isRunning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isRunning ? 'Running...' : 'Run Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Example selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Examples:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_examples.length, (index) {
                        final isSelected = _selectedExample == index;
                        return GestureDetector(
                          onTap: () => _loadExample(index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _examples[index].title,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Code editor and output
          Expanded(
            child: Row(
              children: [
                // Code editor
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D2D2D),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.code,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_examples[_selectedExample].title}.dart',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            maxLines: null,
                            expands: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'monospace',
                              height: 1.5,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                              hintText: 'Write your Flutter/Dart code here...',
                              hintStyle: TextStyle(
                                color: Colors.white38,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Output panel
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.terminal,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Output',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Text(
                                _output.isEmpty
                                    ? 'Click "Run Code" to see the output here...'
                                    : _output,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

class CodeExample {
  final String title;
  final String description;
  final String code;

  CodeExample({
    required this.title,
    required this.description,
    required this.code,
  });
}
