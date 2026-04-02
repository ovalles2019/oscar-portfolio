import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/projects.dart';
import '../../models/project.dart';
import '../../services/download_counter_service.dart';
import '../widgets/ai_chat_widget.dart';
import '../widgets/nav_bar.dart';
import '../widgets/project_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'about': GlobalKey(),
    'projects': GlobalKey(),
    'skills': GlobalKey(),
    'contact': GlobalKey(),
  };

  String _currentSection = 'about';
  List<Project> _projects = [];
  bool _projectsLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    await loadProjects();
    if (!mounted) return;
    setState(() {
      _projects = demoProjects;
      _projectsLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final viewportHeight = MediaQuery.of(context).size.height;
    var activeSection = _currentSection;

    for (final entry in _sectionKeys.entries) {
      final contextForKey = entry.value.currentContext;
      if (contextForKey == null) continue;
      final box = contextForKey.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final offset = box.localToGlobal(Offset.zero).dy;
      if (offset <= viewportHeight * 0.35) {
        activeSection = entry.key;
      }
    }

    if (activeSection != _currentSection && mounted) {
      setState(() => _currentSection = activeSection);
    }
  }

  Future<void> _scrollToSection(String section) async {
    final targetContext = _sectionKeys[section]?.currentContext;
    if (targetContext == null) return;

    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (url.contains('resume.pdf')) {
      try {
        final resumeUrl = Uri.parse('/assets/assets/resume.pdf');
        if (await canLaunchUrl(resumeUrl)) {
          await launchUrl(resumeUrl, mode: LaunchMode.externalApplication);
        } else {
          html.AnchorElement(href: '/assets/assets/resume.pdf')
            ..setAttribute('download', 'Oscar-Valles-Resume.pdf')
            ..click();
        }
        DownloadCounterService.incrementDownloadCount();
        if (mounted) setState(() {});
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Resume download failed. Please try opening it in a new tab.',
            ),
          ),
        );
      }
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _responsiveHorizontalPadding(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: NavBar(
        currentSection: _currentSection,
        onSectionSelected: _scrollToSection,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _PageBackdrop()),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _HeroSection(
                  horizontalPadding: horizontalPadding,
                  onLaunchUrl: _launchUrl,
                  onViewWork: () => _scrollToSection('projects'),
                  onContact: () => _scrollToSection('contact'),
                ),
                _SectionShell(
                  key: _sectionKeys['about'],
                  horizontalPadding: horizontalPadding,
                  child: const _AboutSection(),
                ),
                _SectionShell(
                  key: _sectionKeys['projects'],
                  horizontalPadding: horizontalPadding,
                  child: _ProjectsSection(
                    isLoading: _projectsLoading,
                    projects: _projects,
                  ),
                ),
                _SectionShell(
                  key: _sectionKeys['skills'],
                  horizontalPadding: horizontalPadding,
                  child: const _SkillsSection(),
                ),
                _SectionShell(
                  key: _sectionKeys['contact'],
                  horizontalPadding: horizontalPadding,
                  child: _ContactSection(
                    onLaunchUrl: _launchUrl,
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
          const AIChatWidget(),
        ],
      ),
    );
  }

  double _responsiveHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1400) return 72;
    if (width >= 1024) return 56;
    if (width >= 768) return 32;
    return 20;
  }
}

class _PageBackdrop extends StatelessWidget {
  const _PageBackdrop();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF060B16), Color(0xFF0A1222), Color(0xFF060B16)]
              : const [Color(0xFFF8FAFC), Color(0xFFF3F6FB), Color(0xFFFFFFFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -40,
            child: _GlowOrb(
              size: 320,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
            ),
          ),
          Positioned(
            top: 420,
            right: -100,
            child: _GlowOrb(
              size: 280,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.16),
            ),
          ),
          Positioned(
            bottom: 180,
            left: -60,
            child: _GlowOrb(
              size: 240,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;

  const _SectionShell({
    super.key,
    required this.child,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 96),
      child: child,
    );
  }
}

class _HeroSection extends StatelessWidget {
  final double horizontalPadding;
  final Future<void> Function(BuildContext, String) onLaunchUrl;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const _HeroSection({
    required this.horizontalPadding,
    required this.onLaunchUrl,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 980;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 120, horizontalPadding, 96),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 28 : 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface.withOpacity(0.92),
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.92),
            ],
          ),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                theme.brightness == Brightness.dark ? 0.22 : 0.06,
              ),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: isCompact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroCopy(
                    onLaunchUrl: onLaunchUrl,
                    onViewWork: onViewWork,
                    onContact: onContact,
                  ),
                  const SizedBox(height: 28),
                  const _HeroSpotlightCard(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _HeroCopy(
                      onLaunchUrl: onLaunchUrl,
                      onViewWork: onViewWork,
                      onContact: onContact,
                    ),
                  ),
                  const SizedBox(width: 28),
                  const Expanded(
                    flex: 4,
                    child: _HeroSpotlightCard(),
                  ),
                ],
              ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final Future<void> Function(BuildContext, String) onLaunchUrl;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const _HeroCopy({
    required this.onLaunchUrl,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.22),
            ),
          ),
          child: Text(
            'Open to cloud engineering, platform, and DevOps opportunities',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Designing reliable cloud systems with a sharp product mindset.',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: width < 768 ? 42 : null,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 660),
          child: Text(
            'I help teams turn infrastructure, automation, and modern application development into polished experiences that scale. This portfolio now leads with stronger hierarchy, clearer proof of value, and a more premium visual system.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: onViewWork,
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text('View case studies'),
            ),
            OutlinedButton.icon(
              onPressed: () => onLaunchUrl(context, '/assets/assets/resume.pdf'),
              icon: const Icon(Icons.download_rounded),
              label: Text(DownloadCounterService.downloadCountText),
            ),
            FilledButton.tonalIcon(
              onPressed: onContact,
              icon: const Icon(Icons.arrow_outward_rounded),
              label: const Text('Let’s work together'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _MetricChip(value: 'AWS', label: 'Cloud, IaC, monitoring'),
            _MetricChip(value: 'Flutter', label: 'Web & mobile experiences'),
            _MetricChip(value: 'AI', label: 'Applied ML + automation'),
          ],
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String value;
  final String label;

  const _MetricChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _HeroSpotlightCard extends StatelessWidget {
  const _HeroSpotlightCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.84),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/avatar.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person_rounded,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Oscar Valles', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Cloud engineer • Full-stack developer',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SpotlightRow(
            eyebrow: 'Current focus',
            title: 'Production-ready cloud platforms',
            detail:
                'Shipping scalable dashboards, automation workflows, and AI-enabled tooling with clean UX.',
          ),
          const SizedBox(height: 18),
          _SpotlightRow(
            eyebrow: 'Strengths',
            title: 'Infrastructure + product polish',
            detail:
                'Bridging architecture, implementation, and presentation so technical work feels trustworthy.',
          ),
          const SizedBox(height: 18),
          _SpotlightRow(
            eyebrow: 'Based in',
            title: 'UTD / Texas',
            detail:
                'Open to internships and full-time roles in cloud, DevOps, platform engineering, and applied AI.',
          ),
        ],
      ),
    );
  }
}

class _SpotlightRow extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String detail;

  const _SpotlightRow({
    required this.eyebrow,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: theme.textTheme.bodyMedium?.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(detail, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;

  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(title, style: theme.textTheme.displayMedium),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(description, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 1024;

    final cards = const [
      _ValueCard(
        icon: Icons.cloud_done_rounded,
        title: 'Cloud systems that feel dependable',
        description:
            'I focus on observable, maintainable architecture with strong deployment and operations discipline.',
      ),
      _ValueCard(
        icon: Icons.auto_awesome_rounded,
        title: 'Product thinking in technical work',
        description:
            'Every project is framed around outcomes, clarity, and the confidence a reviewer gets within seconds.',
      ),
      _ValueCard(
        icon: Icons.settings_suggest_rounded,
        title: 'Automation with intention',
        description:
            'I use AI and tooling to remove friction while keeping systems practical, measurable, and easy to hand off.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'About',
          title: 'A sharper story, not just a list of tools.',
          description:
              'To feel professional, the portfolio now emphasizes signal over noise: what you build, how you think, and why your work is valuable to a team.',
        ),
        const SizedBox(height: 32),
        isCompact
            ? Column(
                children: [
                  const _StoryPanel(),
                  const SizedBox(height: 20),
                  ...cards.expand((card) => [card, const SizedBox(height: 16)]),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 5, child: _StoryPanel()),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          cards[i],
                          if (i != cards.length - 1) const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What I bring', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
            'I’m a Computer Engineering master’s student at UTD focused on cloud engineering, DevOps, and applied AI infrastructure roles. My strongest work lives at the intersection of backend reliability, automation, and user-facing polish.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          Text(
            'The goal of this redesign is to present that value faster: fewer gimmicks, stronger structure, clearer case studies, and a visual identity that feels premium without trying too hard.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _MiniStat(label: 'Focus', value: 'Cloud / Platform'),
              _MiniStat(label: 'Approach', value: 'Reliable + polished'),
              _MiniStat(label: 'Strength', value: 'Infra + UX clarity'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.84),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 18),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(description, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  final bool isLoading;
  final List<Project> projects;

  const _ProjectsSection({required this.isLoading, required this.projects});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width >= 1280
        ? (width - 240) / 3
        : width >= 900
            ? (width - 180) / 2
            : double.infinity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Projects',
          title: 'Case studies with clearer proof and stronger presentation.',
          description:
              'A modern portfolio feels more credible when projects read like outcomes, not placeholders. These cards now highlight category, technologies, and the strongest reasons to click deeper.',
        ),
        const SizedBox(height: 32),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          )
        else
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: projects
                .map(
                  (project) => SizedBox(
                    width: cardWidth,
                    child: ProjectCard(project: project),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width >= 1200
        ? (width - 220) / 4
        : width >= 900
            ? (width - 160) / 2
            : double.infinity;

    const cards = [
      _SkillPanel(
        title: 'Cloud & Platform',
        subtitle: 'Reliable infrastructure, deployment, and observability.',
        icon: Icons.cloud_queue_rounded,
        skills: ['AWS', 'Terraform', 'Docker', 'Kubernetes', 'CI/CD'],
      ),
      _SkillPanel(
        title: 'Application Development',
        subtitle: 'Frontend and backend experiences with product-level polish.',
        icon: Icons.devices_rounded,
        skills: ['Flutter', 'React', 'Node.js', 'Python', 'REST APIs'],
      ),
      _SkillPanel(
        title: 'Data & Automation',
        subtitle: 'Insights, intelligent workflows, and operational leverage.',
        icon: Icons.insights_rounded,
        skills: ['DynamoDB', 'PostgreSQL', 'Redis', 'Prometheus', 'AI tooling'],
      ),
      _SkillPanel(
        title: 'Ways of Working',
        subtitle: 'The habits that make technical work feel professional.',
        icon: Icons.rule_folder_rounded,
        skills: ['Documentation', 'Testing', 'Architecture', 'Performance', 'Communication'],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Skills',
          title: 'Capabilities grouped the way hiring teams think.',
          description:
              'Instead of a noisy skills dump, this layout organizes strengths into the themes that matter most: platform reliability, application delivery, automation, and execution quality.',
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: cards
              .map((card) => SizedBox(width: cardWidth, child: card))
              .toList(),
        ),
      ],
    );
  }
}

class _SkillPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> skills;

  const _SkillPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 18),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills
                .map((skill) => Chip(label: Text(skill), visualDensity: VisualDensity.compact))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final Future<void> Function(BuildContext context, String url) onLaunchUrl;

  const _ContactSection({required this.onLaunchUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 920;

    return Container(
      padding: EdgeInsets.all(isCompact ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.14),
            theme.colorScheme.secondary.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ContactCopy(),
                const SizedBox(height: 24),
                _ContactActions(onLaunchUrl: onLaunchUrl),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 5, child: _ContactCopy()),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: _ContactActions(onLaunchUrl: onLaunchUrl),
                ),
              ],
            ),
    );
  }
}

class _ContactCopy extends StatelessWidget {
  const _ContactCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Contact',
          title: 'Ready for opportunities that value ownership and polish.',
          description:
              'If you want someone who cares about infrastructure quality, clean execution, and the way technical work is presented, I’d love to connect.',
        ),
        const SizedBox(height: 18),
        Text(
          'Best fit: cloud engineering, DevOps, platform engineering, and AI infrastructure roles.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _ContactActions extends StatelessWidget {
  final Future<void> Function(BuildContext context, String url) onLaunchUrl;

  const _ContactActions({required this.onLaunchUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactButton(
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: 'ovalles6845@gmail.com',
          onTap: () => onLaunchUrl(context, 'mailto:ovalles6845@gmail.com'),
        ),
        const SizedBox(height: 14),
        _ContactButton(
          icon: Icons.work_outline_rounded,
          title: 'LinkedIn',
          subtitle: 'linkedin.com/in/oscarvalles87',
          onTap: () => onLaunchUrl(
            context,
            'https://www.linkedin.com/in/oscarvalles87/',
          ),
        ),
        const SizedBox(height: 14),
        _ContactButton(
          icon: Icons.code_rounded,
          title: 'GitHub',
          subtitle: 'github.com/ovalles2019',
          onTap: () => onLaunchUrl(context, 'https://github.com/ovalles2019'),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ContactButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.88),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
