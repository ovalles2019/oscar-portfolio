import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingSkillsWidget extends StatefulWidget {
  final Widget child; // The profile picture or content to be surrounded
  final double size;
  
  const FloatingSkillsWidget({
    super.key,
    required this.child,
    this.size = 200,
  });

  @override
  State<FloatingSkillsWidget> createState() => _FloatingSkillsWidgetState();
}

class _FloatingSkillsWidgetState extends State<FloatingSkillsWidget>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _hoverController;
  
  late Animation<double> _orbitAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _hoverAnimation;

  final List<FloatingSkill> _skills = [
    FloatingSkill(
      name: 'AWS',
      color: const Color(0xFFFF9500),
      orbitRadius: 0.8,
      orbitSpeed: 1.0,
      level: 0.9,
    ),
    FloatingSkill(
      name: 'Flutter',
      color: const Color(0xFF1F6F4A),
      orbitRadius: 0.7,
      orbitSpeed: 1.2,
      level: 0.95,
    ),
    FloatingSkill(
      name: 'Python',
      color: const Color(0xFF6FD39B),
      orbitRadius: 0.9,
      orbitSpeed: 0.8,
      level: 0.85,
    ),
    FloatingSkill(
      name: 'Docker',
      color: const Color(0xFF5AC8FA),
      orbitRadius: 0.6,
      orbitSpeed: 1.5,
      level: 0.8,
    ),
    FloatingSkill(
      name: 'AI/ML',
      color: const Color(0xFFAF52DE),
      orbitRadius: 0.75,
      orbitSpeed: 1.1,
      level: 0.75,
    ),
    FloatingSkill(
      name: 'DevOps',
      color: const Color(0xFFFF3B30),
      orbitRadius: 0.85,
      orbitSpeed: 0.9,
      level: 0.9,
    ),
  ];

  int? _hoveredSkillIndex;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _orbitController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _orbitAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _orbitController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _orbitController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onSkillHover(int index, bool isHovered) {
    setState(() {
      _hoveredSkillIndex = isHovered && index >= 0 ? index : null;
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onSkillHover(-1, true),
      onExit: (_) => _onSkillHover(-1, false),
      child: SizedBox(
        width: widget.size * 2.5,
        height: widget.size * 2.5,
        child: Stack(
          children: [
            // Background particles
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _orbitAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BackgroundParticlesPainter(
                      animation: _orbitAnimation.value,
                      isHovered: _isHovered,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),

            // Central content (profile picture)
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: widget.child,
                  );
                },
              ),
            ),

            // Floating skills
            ...List.generate(_skills.length, (index) {
              final skill = _skills[index];
              final angle = (index * 2 * math.pi / _skills.length) + 
                           (_orbitAnimation.value * skill.orbitSpeed);
              
              final x = widget.size * 1.25 + 
                        math.cos(angle) * widget.size * skill.orbitRadius;
              final y = widget.size * 1.25 + 
                        math.sin(angle) * widget.size * skill.orbitRadius;
              
              final isHovered = _hoveredSkillIndex == index;
              final isAnyHovered = _hoveredSkillIndex != null;
              final shouldShow = !isAnyHovered || isHovered;
              
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: x - 40,
                top: y - 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: shouldShow ? 1.0 : 0.3,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isHovered ? 1.1 : 1.0,
                    child: MouseRegion(
                      onEnter: (_) => _onSkillHover(index, true),
                      onExit: (_) => _onSkillHover(index, false),
                      child: GestureDetector(
                        onTap: () {
                          _showSkillDetails(context, skill);
                        },
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            color: skill.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: skill.color.withOpacity(0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: skill.color.withOpacity(0.2),
                                blurRadius: isHovered ? 15 : 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              skill.name,
                              style: TextStyle(
                                color: skill.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Connection lines
            if (_isHovered && _hoveredSkillIndex != null)
              AnimatedBuilder(
                animation: _hoverAnimation,
                builder: (context, child) {
                  final skill = _skills[_hoveredSkillIndex!];
                  final angle = (_hoveredSkillIndex! * 2 * math.pi / _skills.length) + 
                               (_orbitAnimation.value * skill.orbitSpeed);
                  
                  final startX = widget.size * 1.25;
                  final startY = widget.size * 1.25;
                  final endX = widget.size * 1.25 + 
                              math.cos(angle) * widget.size * skill.orbitRadius;
                  final endY = widget.size * 1.25 + 
                              math.sin(angle) * widget.size * skill.orbitRadius;
                  
                  return CustomPaint(
                    painter: ConnectionLinePainter(
                      startX: startX,
                      startY: startY,
                      endX: endX,
                      endY: endY,
                      color: skill.color,
                      animation: _hoverAnimation.value,
                    ),
                    size: Size(widget.size * 2.5, widget.size * 2.5),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showSkillDetails(BuildContext context, FloatingSkill skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: skill.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              skill.name,
              style: TextStyle(
                color: skill.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Proficiency Level: ${(skill.level * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: skill.level,
              backgroundColor: skill.color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(skill.color),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class FloatingSkill {
  final String name;
  final Color color;
  final double orbitRadius;
  final double orbitSpeed;
  final double level;

  FloatingSkill({
    required this.name,
    required this.color,
    required this.orbitRadius,
    required this.orbitSpeed,
    required this.level,
  });
}

class BackgroundParticlesPainter extends CustomPainter {
  final double animation;
  final bool isHovered;

  BackgroundParticlesPainter({
    required this.animation,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1F6F4A).withOpacity(isHovered ? 0.15 : 0.05);

    // Draw subtle background particles
    for (int i = 0; i < 20; i++) {
      final angle = (i * 2 * math.pi / 20) + animation * 0.1;
      final radius = size.width * 0.4 + math.sin(animation + i) * 20;
      
      final x = size.width / 2 + math.cos(angle) * radius;
      final y = size.height / 2 + math.sin(angle) * radius;
      
      final particleSize = 2 + math.sin(animation * 2 + i) * 1;
      
      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ConnectionLinePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final Color color;
  final double animation;

  ConnectionLinePainter({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color.withOpacity(0.6 * animation)
      ..strokeWidth = 2;

    // Draw animated connection line
    final path = Path();
    path.moveTo(startX, startY);
    
    // Add a slight curve to the line
    final controlX = (startX + endX) / 2 + math.sin(animation * math.pi) * 20;
    final controlY = (startY + endY) / 2 + math.cos(animation * math.pi) * 20;
    
    path.quadraticBezierTo(controlX, controlY, endX, endY);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

