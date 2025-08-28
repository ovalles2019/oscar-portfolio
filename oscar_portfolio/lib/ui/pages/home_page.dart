import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../widgets/nav_bar.dart';
import '../widgets/section.dart';
import '../widgets/project_card.dart';
import '../../models/project.dart';
import '../../data/projects.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(),
            const SizedBox(height: 120),
            _AboutSection(),
            const SizedBox(height: 120),
            _ProjectsSection(),
            const SizedBox(height: 120),
            _SkillsSection(),
            const SizedBox(height: 120),
            _ContactSection(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      child: Stack(
        children: [
          // Dynamic background with elegant wave animations
          Positioned.fill(
            child: _AnimatedBackground(),
          ),
          
          // Content on top
          Column(
            children: [
              // Profile picture
              Container(
                width: 140, // Increased from 120
                height: 140, // Increased from 120
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/avatar.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60, // Increased from 50
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Large, impactful title
              Text(
                "Oscar Valles",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -2.0,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Subtitle with Apple-style typography
              Text(
                "Cloud Engineer & Full-Stack Developer",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Description with clean, readable text
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  "Building scalable cloud solutions with AWS, Flutter, and modern technologies. "
                  "Passionate about creating efficient, reliable, and user-friendly applications.",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              
              // Action buttons with Apple-style design
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Primary button - Download Resume
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF007AFF).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _launchUrl('assets/resume.pdf'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "Download Resume",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Secondary button - Get In Touch
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF34C759).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: () => _scrollToSection(context, "contact"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF34C759),
                        side: const BorderSide(color: Color(0xFF34C759), width: 2),
                        backgroundColor: const Color(0xFF34C759).withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Get In Touch",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _scrollToSection(BuildContext context, String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scrolling to $section section...')),
    );
  }

  Future<void> _launchUrl(String url) async {
    print('Resume download requested for: $url');
  }
}

class _AnimatedBackground extends StatefulWidget {
  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _CloudPainter(_animation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CloudPainter extends CustomPainter {
  final double animationValue;

  _CloudPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF007AFF).withOpacity(0.03) // Fixed color instead of Theme.of(context)
      ..style = PaintingStyle.fill;

    // Multiple floating clouds with different speeds and positions
    _drawCloud(canvas, size, paint, 0.1, 0.2, 0.8);
    _drawCloud(canvas, size, paint, 0.3, 0.7, 0.6);
    _drawCloud(canvas, size, paint, 0.6, 0.3, 0.9);
    _drawCloud(canvas, size, paint, 0.8, 0.8, 0.7);
    _drawCloud(canvas, size, paint, 0.2, 0.5, 0.5);
  }

  void _drawCloud(Canvas canvas, Size size, Paint paint, double x, double y, double speed) {
    final cloudX = (x + animationValue * speed) * size.width;
    final cloudY = y * size.height;
    
    // Draw cloud using multiple circles
    canvas.drawCircle(
      Offset(cloudX, cloudY),
      40,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 30, cloudY),
      35,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 60, cloudY),
      30,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 15, cloudY - 20),
      25,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 45, cloudY - 15),
      20,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          // Subtle animated background
          Positioned.fill(
            child: _SubtleAnimatedBackground(),
          ),
          
          // Content
          Column(
            children: [
              // Section header with Apple-style typography
              Text(
                "About Me",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              Text(
                "Passionate Cloud Engineer with expertise in AWS and modern development",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // About text
              Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Text(
                  "I'm a Cloud Engineer with a passion for building scalable, efficient solutions. "
                  "My expertise lies in AWS cloud services, serverless architectures, and modern web development. "
                  "I love tackling complex problems and turning ideas into reality through clean, maintainable code.",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 80),
              
              // Feature cards in a row
              Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.cloud,
                      title: "Cloud Solutions",
                      description: "AWS, Serverless, Microservices",
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.code,
                      title: "Full-Stack Development",
                      description: "Flutter, Web, Mobile Apps",
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.architecture,
                      title: "System Design",
                      description: "Scalable, Reliable, Efficient",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubtleAnimatedBackground extends StatefulWidget {
  @override
  State<_SubtleAnimatedBackground> createState() => _SubtleAnimatedBackgroundState();
}

class _SubtleAnimatedBackgroundState extends State<_SubtleAnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _SubtleCloudPainter(_animation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SubtleCloudPainter extends CustomPainter {
  final double animationValue;

  _SubtleCloudPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF007AFF).withOpacity(0.02) // Fixed color instead of Theme.of(context)
      ..style = PaintingStyle.fill;

    // Subtle floating clouds for sections
    _drawSubtleCloud(canvas, size, paint, 0.1, 0.1, 0.4);
    _drawSubtleCloud(canvas, size, paint, 0.8, 0.2, 0.3);
    _drawSubtleCloud(canvas, size, paint, 0.3, 0.8, 0.5);
    _drawSubtleCloud(canvas, size, paint, 0.7, 0.7, 0.6);
  }

  void _drawSubtleCloud(Canvas canvas, Size size, Paint paint, double x, double y, double speed) {
    final cloudX = (x + animationValue * speed) * size.width;
    final cloudY = y * size.height;
    
    // Draw smaller, more subtle clouds
    canvas.drawCircle(
      Offset(cloudX, cloudY),
      25,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 20, cloudY),
      20,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 40, cloudY),
      15,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 10, cloudY - 15),
      12,
      paint,
    );
    canvas.drawCircle(
      Offset(cloudX + 30, cloudY - 10),
      10,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isHovered 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7280).withOpacity(0.08), // Soft gray shadow
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: const Color(0xFF6B7280).withOpacity(0.12), // Slightly stronger on hover
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isHovered 
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 32,
                      color: _isHovered 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _isHovered 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProjectsSection extends StatefulWidget {
  @override
  State<_ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<_ProjectsSection>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _autoPlayController;
  int _currentPage = 0;
  final List<Project> _projects = [
    Project(
      title: "Cloud Infrastructure Automation",
      description: "Designed and implemented automated cloud infrastructure using Terraform and AWS services, reducing deployment time by 80% and improving scalability.",
      tags: ["AWS", "Terraform", "DevOps", "Python"],
      link: "https://github.com/example/cloud-automation",
    ),
    Project(
      title: "Real-time Chat Application",
      description: "Built a scalable real-time chat application using Flutter and Firebase, supporting thousands of concurrent users with real-time messaging.",
      tags: ["Flutter", "Firebase", "Real-time", "Mobile"],
      link: "https://github.com/example/chat-app",
    ),
    Project(
      title: "E-commerce Platform",
      description: "Developed a full-stack e-commerce solution with React frontend and Node.js backend, featuring payment integration and inventory management.",
      tags: ["React", "Node.js", "MongoDB", "Stripe"],
      link: "https://github.com/example/ecommerce",
    ),
    Project(
      title: "Infrastructure as Code with Terraform",
      description: "Created reusable Terraform modules for AWS infrastructure, enabling consistent deployments across multiple environments.",
      tags: ["Terraform", "AWS", "Infrastructure", "Automation"],
      link: "https://github.com/example/terraform-modules",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _autoPlayController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    // Auto-play the carousel
    _startAutoPlay();
    
    // Listen to page changes
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoPlayController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentPage < _projects.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        }
        _autoPlayController.reset();
        _autoPlayController.forward();
      }
    });
    _autoPlayController.forward();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _currentPage = page);
    
    // Reset auto-play
    _autoPlayController.reset();
    _autoPlayController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          // Subtle animated background
          Positioned.fill(
            child: _SubtleAnimatedBackground(),
          ),
          
          // Content
          Column(
            children: [
              Text(
                "Featured Projects",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              Text(
                "Explore my latest work and creative solutions",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // Projects Carousel
              Container(
                height: 500,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        
                        return Transform.scale(
                          scale: Curves.easeOutCubic.transform(value),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ProjectCard(project: project),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Navigation Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_projects.length, (index) {
                  return GestureDetector(
                    onTap: () => _goToPage(index),
                    child: Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 20),
              
              // View All Projects Button
              ElevatedButton(
                onPressed: () {
                  // Scroll to show all projects or expand the view
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Viewing all projects...'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: const Text("View All Projects"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillsSection extends StatefulWidget {
  @override
  State<_SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<_SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          // Subtle animated background
          Positioned.fill(
            child: _SubtleAnimatedBackground(),
          ),
          
          // Content
          Column(
            children: [
              Text(
                "Skills & Technologies",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              Text(
                "Technologies I work with and areas of expertise",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              
              // Four large sections in 2x2 grid (Apple-style)
              Column(
                children: [
                  // Top row - two large sections
                  Row(
                    children: [
                      // Top-left section - Cloud & DevOps
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatAnimation.value * 0.8),
                              child: Container(
                                height: 300,
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6B7280).withOpacity(0.08), // Soft gray shadow
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF007AFF).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Icon(
                                              Icons.cloud,
                                              size: 32,
                                              color: Color(0xFF007AFF),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              "Cloud & DevOps",
                                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).colorScheme.onSurface,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        "Building scalable infrastructure with modern cloud technologies",
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: ["AWS", "Docker", "Kubernetes", "CI/CD", "Terraform"]
                                            .map((skill) => Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF007AFF).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(
                                                      color: const Color(0xFF007AFF).withOpacity(0.2),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    skill,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF007AFF),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Top-right section - Programming
                      Expanded(
                        child: Container(
                          height: 300,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF34C759).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.code,
                                        size: 32,
                                        color: Color(0xFF34C759),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        "Programming",
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Creating robust applications with modern programming languages",
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: ["Dart/Flutter", "Python", "JavaScript", "TypeScript", "Java"]
                                      .map((skill) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF34C759).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(0xFF34C759).withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              skill,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF34C759),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Bottom row - two large sections
                  Row(
                    children: [
                      // Bottom-left section - Databases
                      Expanded(
                        child: Container(
                          height: 300,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9500).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.storage,
                                        size: 32,
                                        color: Color(0xFFFF9500),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        "Databases",
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Designing efficient data storage and retrieval systems",
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: ["DynamoDB", "PostgreSQL", "MongoDB", "Redis"]
                                      .map((skill) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFF9500).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(0xFFFF9500).withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              skill,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFFF9500),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Bottom-right section - Tools & Frameworks
                      Expanded(
                        child: Container(
                          height: 300,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFAF52DE).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.build,
                                        size: 32,
                                        color: Color(0xFFAF52DE),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        "Tools & Frameworks",
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Leveraging powerful tools for efficient development workflows",
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: ["Git", "VS Code", "Postman", "Jira", "Confluence"]
                                      .map((skill) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFAF52DE).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(0xFFAF52DE).withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              skill,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFAF52DE),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          // Subtle animated background
          Positioned.fill(
            child: _SubtleAnimatedBackground(),
          ),
          
          // Content
          Column(
            children: [
              Text(
                "Get In Touch",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              Text(
                "Let's discuss how we can work together",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  "I'm always interested in new opportunities and exciting projects. "
                  "Whether you have a question or just want to say hi, feel free to reach out!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ContactButton(
                    icon: Icons.email,
                    title: "Email",
                    onTap: () => _launchUrl('mailto:oscar@example.com'),
                  ),
                  const SizedBox(width: 20),
                  _ContactButton(
                    icon: Icons.link,
                    title: "LinkedIn",
                    onTap: () => _launchUrl('https://linkedin.com/in/oscarvalles'),
                  ),
                  const SizedBox(width: 20),
                  _ContactButton(
                    icon: Icons.code,
                    title: "GitHub",
                    onTap: () => _launchUrl('https://github.com/oscarvalles'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class _ContactButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ContactButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: _isHovered 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: _isHovered ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: _isHovered 
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: _isHovered 
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
