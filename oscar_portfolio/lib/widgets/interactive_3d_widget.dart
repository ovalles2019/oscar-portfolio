import 'package:flutter/material.dart';
import 'dart:math' as math;

class Interactive3DWidget extends StatefulWidget {
  const Interactive3DWidget({super.key});

  @override
  State<Interactive3DWidget> createState() => _Interactive3DWidgetState();
}

class _Interactive3DWidgetState extends State<Interactive3DWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  final List<Particle> _particles = [];
  final List<Skill3D> _skills = [
    Skill3D(name: 'AWS', level: 0.9, color: Colors.orange),
    Skill3D(name: 'Flutter', level: 0.95, color: Colors.blue),
    Skill3D(name: 'Python', level: 0.85, color: Colors.green),
    Skill3D(name: 'Docker', level: 0.8, color: Colors.cyan),
    Skill3D(name: 'AI/ML', level: 0.75, color: Colors.purple),
    Skill3D(name: 'DevOps', level: 0.9, color: Colors.red),
  ];

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _initializeParticles();
    _rotationController.repeat();
    _particleController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.5 + 0.1,
        opacity: random.nextDouble() * 0.5 + 0.3,
      ));
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
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
                    Icons.view_in_ar,
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
                        '3D Skill Visualization',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Interactive 3D representation of skills',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3D Visualization
          Expanded(
            child: Stack(
              children: [
                // Particle background
                AnimatedBuilder(
                  animation: _particleAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ParticlePainter(
                        particles: _particles,
                        animation: _particleAnimation.value,
                      ),
                      size: Size.infinite,
                    );
                  },
                ),

                // 3D Skills sphere
                Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationAnimation,
                      _pulseAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: CustomPaint(
                          painter: SkillSpherePainter(
                            skills: _skills,
                            rotation: _rotationAnimation.value,
                          ),
                          size: const Size(300, 300),
                        ),
                      );
                    },
                  ),
                ),

                // Interactive skill cards
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _skills.length,
                      itemBuilder: (context, index) {
                        final skill = _skills[index];
                        return GestureDetector(
                          onTap: () {
                            _highlightSkill(index);
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: skill.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: skill.color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  skill.name,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: skill.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: skill.color.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: skill.level,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: skill.color,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  void _highlightSkill(int index) {
    // Add highlight animation logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_skills[index].name}: ${(_skills[index].level * 100).toInt()}% proficiency'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class Skill3D {
  String name;
  double level;
  Color color;

  Skill3D({
    required this.name,
    required this.level,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.1);

    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = particle.y * size.height + (animation * 20);
      final radius = particle.size * (1 + animation * 0.5);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = Colors.blue.withOpacity(particle.opacity * (1 - animation * 0.3)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SkillSpherePainter extends CustomPainter {
  final List<Skill3D> skills;
  final double rotation;

  SkillSpherePainter({
    required this.skills,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw sphere outline
    final spherePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, spherePaint);

    // Draw skill points
    for (int i = 0; i < skills.length; i++) {
      final skill = skills[i];
      final angle = (i * 2 * math.pi / skills.length) + rotation;
      final x = center.dx + math.cos(angle) * radius * 0.8;
      final y = center.dy + math.sin(angle) * radius * 0.8;

      final skillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = skill.color;

      final skillRadius = 8 + (skill.level * 8);
      canvas.drawCircle(Offset(x, y), skillRadius, skillPaint);

      // Draw skill name
      final textPainter = TextPainter(
        text: TextSpan(
          text: skill.name,
          style: TextStyle(
            color: skill.color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y + skillRadius + 5),
      );
    }

    // Draw connecting lines
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i < skills.length; i++) {
      final angle1 = (i * 2 * math.pi / skills.length) + rotation;
      final angle2 = ((i + 1) % skills.length) * 2 * math.pi / skills.length + rotation;
      
      final x1 = center.dx + math.cos(angle1) * radius * 0.8;
      final y1 = center.dy + math.sin(angle1) * radius * 0.8;
      final x2 = center.dx + math.cos(angle2) * radius * 0.8;
      final y2 = center.dy + math.sin(angle2) * radius * 0.8;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
