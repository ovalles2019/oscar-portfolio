import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/ai_chat_widget.dart';
import '../../widgets/ai_resume_widget.dart';
import '../../widgets/code_playground_widget.dart';
import '../../widgets/interactive_3d_widget.dart';
import '../../widgets/job_analyzer_widget.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/scroll_animations.dart';

class InteractiveFeaturesPage extends StatefulWidget {
  const InteractiveFeaturesPage({super.key});

  @override
  State<InteractiveFeaturesPage> createState() => _InteractiveFeaturesPageState();
}

class _InteractiveFeaturesPageState extends State<InteractiveFeaturesPage>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;

  @override
  void initState() {
    super.initState();
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _mainAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

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
            child: Container(
              padding: ResponsiveHelper.responsivePadding(
                context,
                mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                tablet: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
                desktop: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              ),
              child: Column(
                children: [
                  // Hero Section
                  AnimatedBuilder(
                    animation: _mainAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: _slideUpAnimation,
                          child: Column(
                            children: [
                              Text(
                                "Interactive Features",
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -2.0,
                                  height: 1.1,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                    context,
                                    mobile: 40,
                                    tablet: 48,
                                    desktop: 56,
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
                              
                              Container(
                                constraints: const BoxConstraints(maxWidth: 600),
                                child: Text(
                                  "Experience cutting-edge interactive features that showcase my technical expertise and innovation.",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.5,
                                    height: 1.4,
                                    fontSize: ResponsiveHelper.responsiveFontSize(
                                      context,
                                      mobile: 18,
                                      tablet: 20,
                                      desktop: 22,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 40,
                    tablet: 60,
                    desktop: 80,
                  )),

                  // Interactive Features Grid
                  StaggeredAnimation(
                    staggerDelay: const Duration(milliseconds: 200),
                    children: [
                      ResponsiveGrid(
                        children: [
                          _FeatureCard(
                            title: "AI Resume Assistant",
                            description: "Ask questions about my experience, skills, and projects. Get instant, intelligent responses powered by AI.",
                            icon: Icons.psychology,
                            color: Colors.purple,
                            child: AIResumeWidget(),
                          ),
                          _FeatureCard(
                            title: "Live Code Playground",
                            description: "Try Flutter/Dart code snippets in real-time. See live output and experiment with different examples.",
                            icon: Icons.code,
                            color: Colors.blue,
                            child: CodePlaygroundWidget(),
                          ),
                          _FeatureCard(
                            title: "3D Skill Visualization",
                            description: "Interactive 3D sphere showing my technical skills with floating particles and dynamic animations.",
                            icon: Icons.view_in_ar,
                            color: Colors.green,
                            child: Interactive3DWidget(),
                          ),
                          _FeatureCard(
                            title: "Job Description Analyzer",
                            description: "Paste any job description and get instant skill matching analysis with compatibility scores.",
                            icon: Icons.analytics,
                            color: Colors.orange,
                            child: JobAnalyzerWidget(),
                          ),
                        ],
                        mobileColumns: 1,
                        tabletColumns: 2,
                        desktopColumns: 2,
                        spacing: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 32,
                        ),
                        runSpacing: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 32,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 40,
                    tablet: 60,
                    desktop: 80,
                  )),

                  // Call to Action
                  Container(
                    padding: ResponsiveHelper.responsivePadding(
                      context,
                      mobile: const EdgeInsets.all(24),
                      tablet: const EdgeInsets.all(32),
                      desktop: const EdgeInsets.all(40),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Ready to Collaborate?",
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        )),
                        Text(
                          "These interactive features demonstrate my technical skills and innovative approach to problem-solving. Let's discuss how I can bring this level of creativity and expertise to your next project.",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 24,
                          tablet: 32,
                          desktop: 40,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/contact');
                              },
                              icon: const Icon(Icons.email),
                              label: const Text('Get In Touch'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.responsiveValue(
                              context,
                              mobile: 12,
                              tablet: 16,
                              desktop: 20,
                            )),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/projects');
                              },
                              icon: const Icon(Icons.work),
                              label: const Text('View Projects'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // AI Chat Widget
          const AIChatWidget(),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget child;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.color.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.1),
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
                      color: widget.color.withOpacity(0.1),
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
                            color: widget.color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            widget.icon,
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
                                widget.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                widget.description,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: widget.color,
                        ),
                      ],
                    ),
                  ),

                  // Content
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isExpanded ? 500 : 0,
                    child: _isExpanded
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: widget.child,
                          )
                        : const SizedBox.shrink(),
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
