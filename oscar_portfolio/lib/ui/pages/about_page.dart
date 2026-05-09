import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../widgets/nav_bar.dart';
import '../widgets/ai_chat_widget.dart';
import '../../widgets/floating_skills_widget.dart';
import '../../services/download_counter_service.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/scroll_animations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ResponsiveHelper.responsiveValue(
          context,
          mobile: 56,
          tablet: 60,
          desktop: 64,
        )),
        child: NavBar(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ScrollRevealAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: _HeroSection(onLaunchUrl: _launchUrl),
                ),
                SizedBox(height: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 60,
                  tablet: 80,
                  desktop: 120,
                )),
                ScrollRevealAnimation(
                  delay: const Duration(milliseconds: 400),
                  child: _AboutSection(),
                ),
                SizedBox(height: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 60,
                  tablet: 80,
                  desktop: 120,
                )),
              ],
            ),
          ),
          // AI Chat Widget
          const AIChatWidget(),
        ],
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (url.contains('resume.pdf')) {
      try {
        // For Flutter web, use the correct asset path
        final resumeUrl = Uri.parse('/assets/assets/resume.pdf');
        
        // Try to launch the URL directly
        if (await canLaunchUrl(resumeUrl)) {
          await launchUrl(resumeUrl, mode: LaunchMode.externalApplication);
          // Increment download counter
          DownloadCounterService.incrementDownloadCount();
          // Trigger rebuild to update counter display
          if (mounted) setState(() {});
        } else {
          // Fallback: create a download link
          html.AnchorElement(href: '/assets/assets/resume.pdf')
            ..setAttribute('download', 'resume.pdf')
              ..click();
          // Increment download counter
          DownloadCounterService.incrementDownloadCount();
          // Trigger rebuild to update counter display
          if (mounted) setState(() {});
        }
          } catch (e) {
        // Show error message with helpful instructions
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
            content: Text('Resume download failed. Please try right-clicking the button and select "Save as..."'),
            duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Copy Link',
                  onPressed: () {
                    // Copy the direct link to clipboard
                    html.window.navigator.clipboard?.writeText('/assets/assets/resume.pdf');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Link copied to clipboard!')),
                    );
                  },
                ),
          ),
        );
      }
    } else if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class _HeroSection extends StatelessWidget {
  final Future<void> Function(BuildContext, String) onLaunchUrl;
  
  const _HeroSection({required this.onLaunchUrl});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.responsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        tablet: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        desktop: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      ),
      child: Stack(
        children: [
          // Dynamic background with elegant wave animations
          Positioned.fill(
            child: _AnimatedBackground(),
          ),
          
          // Content on top
          Column(
            children: [
              // Interactive 3D Skills Visualization with Profile Picture
              Center(
                child: FloatingSkillsWidget(
                  size: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 100,
                    tablet: 120,
                    desktop: 140,
                  ),
                  child: HoverScaleAnimation(
                    scale: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 1.05,
                      tablet: 1.08,
                      desktop: 1.1,
                    ),
                    child: Container(
                      width: ResponsiveHelper.responsiveValue(
                        context,
                        mobile: 120,
                        tablet: 140,
                        desktop: 160,
                      ),
                      height: ResponsiveHelper.responsiveValue(
                        context,
                        mobile: 120,
                        tablet: 140,
                        desktop: 160,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
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
                                size: 60,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              )),
              
              // Large, impactful title
              Text(
                "Oscar Valles",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -2.0,
                  height: 1.1,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    mobile: 48,
                    tablet: 56,
                    desktop: 64,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              )),
              
              // Subtitle with Apple-style typography
              Text(
                "Cloud Engineer & Full-Stack Developer",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 28,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              )),
              
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
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 768) {
                    // Mobile layout - stacked vertically
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1F6F4A).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => onLaunchUrl(context, '/assets/assets/resume.pdf'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F6F4A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                shadowColor: Colors.transparent,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    DownloadCounterService.downloadCountText,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6FD39B).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/contact');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF6FD39B),
                                side: const BorderSide(color: Color(0xFF6FD39B), width: 2),
                                backgroundColor: const Color(0xFF6FD39B).withOpacity(0.1),
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
                        ),
                      ],
                    );
                  } else {
                    // Desktop layout - side by side
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1F6F4A).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => onLaunchUrl(context, 'assets/resume.pdf'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F6F4A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              shadowColor: Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  DownloadCounterService.downloadCountText,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6FD39B).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/contact');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6FD39B),
                              side: const BorderSide(color: Color(0xFF6FD39B), width: 2),
                              backgroundColor: const Color(0xFF6FD39B).withOpacity(0.1),
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
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
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
      ..color = const Color(0xFF1F6F4A).withOpacity(0.03) // Fixed color instead of Theme.of(context)
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 768 ? 20 : 40,
      ),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 900;
                  final textBlock = Column(
                    crossAxisAlignment:
                        isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Crafting cloud-native systems with clean design, clear data, and reliable delivery.",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                        textAlign: isCompact ? TextAlign.center : TextAlign.left,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "I'm a Master's student in Computer Engineering at UTD building ML-powered and automated systems. "
                        "I focus on scalable architecture, observability, and thoughtful UX across cloud products.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: isCompact ? TextAlign.center : TextAlign.left,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment:
                            isCompact ? WrapAlignment.center : WrapAlignment.start,
                        children: const [
                          _AboutPill(
                            icon: Icons.cloud_done_outlined,
                            label: "AWS + Kubernetes",
                          ),
                          _AboutPill(
                            icon: Icons.monitor_heart_outlined,
                            label: "Observability",
                          ),
                          _AboutPill(
                            icon: Icons.auto_awesome_outlined,
                            label: "AI Workflows",
                          ),
                        ],
                      ),
                    ],
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        const _AboutPhoneMockup(),
                        const SizedBox(height: 32),
                        textBlock,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: textBlock),
                      const SizedBox(width: 48),
                      const _AboutPhoneMockup(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 80),
              
              // Feature cards in responsive layout
              StaggeredAnimation(
                staggerDelay: const Duration(milliseconds: 150),
                children: [
                  ResponsiveGrid(
                    children: [
                      _FeatureCard(
                        icon: Icons.cloud,
                        title: "Cloud Solutions",
                        description: "AWS, Serverless, Microservices",
                      ),
                      _FeatureCard(
                        icon: Icons.code,
                        title: "Full-Stack Development",
                        description: "Flutter, Web, Mobile Apps",
                      ),
                      _FeatureCard(
                        icon: Icons.architecture,
                        title: "System Design",
                        description: "Scalable, Reliable, Efficient",
                      ),
                      _FeatureCard(
                        icon: Icons.psychology,
                        title: "AI Infrastructure",
                        description: "ML Pipelines, Data Science, Automation",
                      ),
                    ],
                    mobileColumns: 1,
                    tabletColumns: 2,
                    desktopColumns: 2,
                    spacing: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                    runSpacing: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
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

class _AboutPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AboutPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPhoneMockup extends StatefulWidget {
  const _AboutPhoneMockup();

  @override
  State<_AboutPhoneMockup> createState() => _AboutPhoneMockupState();
}

class _AboutPhoneMockupState extends State<_AboutPhoneMockup>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _statIndex = 0;

  final List<Map<String, String>> _statSets = const [
    {
      'projects': '08',
      'apps': '04',
      'label': 'Active sprint',
    },
    {
      'projects': '12',
      'apps': '06',
      'label': 'Delivery week',
    },
    {
      'projects': '05',
      'apps': '03',
      'label': 'Research mode',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _cycleStats() {
    setState(() {
      _statIndex = (_statIndex + 1) % _statSets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = const Color(0xFF6FD39B);
    final surface = Theme.of(context).cardColor;
    final currentSet = _statSets[_statIndex];

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: _cycleStats,
          child: Container(
            width: 320,
            height: 640,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1C16),
              borderRadius: BorderRadius.circular(46),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Container(
                  color: surface,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.08),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "9:41",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.signal_cellular_alt,
                                            size: 16, color: primary),
                                        const SizedBox(width: 6),
                                        Icon(Icons.wifi, size: 16, color: primary),
                                        const SizedBox(width: 6),
                                        Icon(Icons.battery_full,
                                            size: 16, color: primary),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: primary.withOpacity(0.15),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/avatar.jpg',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.person, color: primary);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Welcome, Oscar",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            currentSet['label'] ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.6),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Icon(Icons.notifications_none, color: primary),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: secondary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: secondary.withOpacity(0.6),
                                                blurRadius: 6,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Upcoming Deliverables",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "View all",
                                        style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        _MiniPill(label: "Tue"),
                                        const SizedBox(width: 8),
                                        _MiniPill(label: "Thu"),
                                        const SizedBox(width: 8),
                                        _MiniPill(label: "Sat"),
                                        const Spacer(),
                                        Icon(Icons.calendar_month_outlined,
                                            color: primary),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Transform.translate(
                                    offset: Offset(0, _pulseAnimation.value * 0.4),
                                    child: _ListTileCard(
                                      title: "Infra Insights",
                                      subtitle: "Cost optimization review",
                                      accent: primary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Transform.translate(
                                    offset: Offset(0, -_pulseAnimation.value * 0.4),
                                    child: _ListTileCard(
                                      title: "Realtime Analytics",
                                      subtitle: "Dashboard polish",
                                      accent: secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Dashboard Stats",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _StatCard(
                                          label: "Projects",
                                          value: currentSet['projects'] ?? '--',
                                          color: primary.withOpacity(0.1),
                                          icon: Icons.layers_outlined,
                                          isActive: true,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _StatCard(
                                          label: "Live Apps",
                                          value: currentSet['apps'] ?? '--',
                                          color: secondary.withOpacity(0.15),
                                          icon: Icons.rocket_launch_outlined,
                                          isActive: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.touch_app_outlined,
                                          size: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5)),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Tap to cycle stats",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.08),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.home_rounded, color: primary),
                                Icon(Icons.analytics_outlined, color: primary),
                                Icon(Icons.chat_bubble_outline, color: primary),
                                Icon(Icons.settings_outlined, color: primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 140,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
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
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;

  const _MiniPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;

  const _ListTileCard({
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: accent.withOpacity(0.08),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.task_alt, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isActive;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                size: 18, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
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
      ..color = const Color(0xFF1F6F4A).withOpacity(0.02) // Fixed color instead of Theme.of(context)
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
    return HoverScaleAnimation(
      scale: ResponsiveHelper.responsiveValue(
        context,
        mobile: 1.02,
        tablet: 1.03,
        desktop: 1.05,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Container(
                padding: ResponsiveHelper.responsivePadding(
                  context,
                  mobile: const EdgeInsets.all(24),
                  tablet: const EdgeInsets.all(32),
                  desktop: const EdgeInsets.all(40),
                ),
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
    ),
    );
  }
}
