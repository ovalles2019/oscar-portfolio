import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/projects.dart';
import '../../models/project.dart';
import '../widgets/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Project> _projects = [];
  bool _loading = true;
  late AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..forward();
    _load();
  }

  Future<void> _load() async {
    try {
      await loadProjects();
      if (!mounted) return;
      setState(() {
        _projects = demoProjects.take(3).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    Uri u;
    if (url.startsWith('/')) {
      u = Uri.base.resolve(url);
    } else {
      u = Uri.parse(url);
    }
    if (await canLaunchUrl(u)) {
      await launchUrl(u, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 900;
    final pad = compact ? 22.0 : 56.0;
    const maxW = 1140.0;
    final gap = compact ? 100.0 : 140.0;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AnimatedBg()),
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: NavBar()),
              SliverToBoxAdapter(
                child: _Hero(
                  entrance: _entrance,
                  pad: pad,
                  maxW: maxW,
                  compact: compact,
                  onWork: () => Navigator.of(context).pushNamed('/projects'),
                  onResume: () => _open('/assets/assets/resume.pdf'),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: gap)),
              SliverToBoxAdapter(
                child: _Section(
                  pad: pad,
                  maxW: maxW,
                  eyebrow: 'SELECTED WORK',
                  title: 'Projects built for production.',
                  sub: 'Cloud infrastructure, full-stack apps, and systems that actually hold up under real load.',
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 36)),
              SliverToBoxAdapter(
                child: _ProjectStrip(
                  pad: pad,
                  maxW: maxW,
                  compact: compact,
                  loading: _loading,
                  projects: _projects,
                  onOpen: _open,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: gap)),
              SliverToBoxAdapter(
                child: _Section(
                  pad: pad,
                  maxW: maxW,
                  eyebrow: 'CAPABILITIES',
                  title: 'Full-stack. Cloud-native. Production-ready.',
                  sub: 'I work across application, infrastructure, and delivery layers.',
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 36)),
              SliverToBoxAdapter(
                child: _BentoGrid(pad: pad, maxW: maxW, compact: compact),
              ),
              SliverToBoxAdapter(child: SizedBox(height: gap)),
              SliverToBoxAdapter(
                child: _CtaBlock(
                  pad: pad,
                  maxW: maxW,
                  onContact: () => Navigator.of(context).pushNamed('/contact'),
                  onEmail: () => _open('mailto:ovalles6845@gmail.com'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 36),
                  child: Center(
                    child: Text(
                      '© ${DateTime.now().year} Oscar Valles',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.35),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HERO — profile card with photo + gradient bg
// ═══════════════════════════════════════════════════════════════════════════

class _Hero extends StatelessWidget {
  final AnimationController entrance;
  final double pad, maxW;
  final bool compact;
  final VoidCallback onWork, onResume;

  const _Hero({
    required this.entrance,
    required this.pad,
    required this.maxW,
    required this.compact,
    required this.onWork,
    required this.onResume,
  });

  Animation<double> _fade(double s, double e) =>
      CurvedAnimation(parent: entrance, curve: Interval(s, e, curve: Curves.easeOut));
  Animation<Offset> _slide(double s, double e) =>
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
          .animate(CurvedAnimation(parent: entrance, curve: Interval(s, e, curve: Curves.easeOutCubic)));

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, 40, pad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile card ──
              FadeTransition(
                opacity: _fade(0.0, 0.5),
                child: SlideTransition(
                  position: _slide(0.0, 0.5),
                  child: _ProfileCard(compact: compact),
                ),
              ),
              const SizedBox(height: 48),

              // ── Headline below card ──
              FadeTransition(
                opacity: _fade(0.2, 0.58),
                child: SlideTransition(
                  position: _slide(0.2, 0.58),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [s.onSurface, s.primary, s.secondary],
                      stops: const [0.0, 0.6, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      'Building Cloud, AI,\nand Scalable Systems',
                      style: tt.displayLarge?.copyWith(
                        fontSize: compact ? 38 : 60,
                        height: 1.0,
                        letterSpacing: -2.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Tagline ──
              FadeTransition(
                opacity: _fade(0.28, 0.62),
                child: SlideTransition(
                  position: _slide(0.28, 0.62),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      'I architect production-grade cloud systems and build '
                      'interfaces that turn complex infrastructure into '
                      'something people can actually use.',
                      style: tt.bodyLarge?.copyWith(fontSize: compact ? 15 : 17),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ── Buttons ──
              FadeTransition(
                opacity: _fade(0.35, 0.68),
                child: SlideTransition(
                  position: _slide(0.35, 0.68),
                  child: Wrap(spacing: 12, runSpacing: 12, children: [
                    _GradientBtn(label: 'Explore Work', onTap: onWork, scheme: s),
                    OutlinedButton(
                      onPressed: onResume,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded, size: 16, color: s.onSurface),
                          const SizedBox(width: 8),
                          const Text('Resume'),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 48),

              // ── Divider ──
              FadeTransition(
                opacity: _fade(0.45, 0.72),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      s.primary.withValues(alpha: 0.3),
                      s.tertiary.withValues(alpha: 0.15),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Metrics ──
              FadeTransition(
                opacity: _fade(0.5, 0.8),
                child: SlideTransition(
                  position: _slide(0.5, 0.8),
                  child: Wrap(
                    spacing: compact ? 24 : 48,
                    runSpacing: 16,
                    children: [
                      _Stat('6+', 'Projects', s),
                      _Stat('AWS', 'Certified', s),
                      _Stat('MS CS', 'UTD', s),
                      _Stat('E2E', 'Full-Stack', s),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 44),

              FadeTransition(
                opacity: _fade(0.65, 0.92),
                child: Center(child: _ScrollHint(color: s.onSurfaceVariant)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Glossy profile card with photo + glassmorphism ────────────────────────

class _ProfileCard extends StatelessWidget {
  final bool compact;
  const _ProfileCard({required this.compact});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    if (compact) {
      return Column(children: [
        _PhotoBlock(height: 340),
        const SizedBox(height: 20),
        _InfoPanel(compact: true),
      ]);
    }

    return Container(
      height: 440,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: s.surface.withValues(alpha: 0.35),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: s.primary.withValues(alpha: 0.06),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(flex: 5, child: _PhotoBlock()),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  s.surface.withValues(alpha: 0.5),
                  s.surface.withValues(alpha: 0.25),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoPanel(compact: false),
                const Spacer(),
                _GlossyBadge(scheme: s),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _PhotoBlock extends StatelessWidget {
  final double? height;
  const _PhotoBlock({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: height != null ? BorderRadius.circular(24) : null,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEC4899),
            Color(0xFFA855F7),
            Color(0xFF6366F1),
            Color(0xFF3B82F6),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/profile.png',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.2),
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.person, size: 80, color: Colors.white38),
            ),
          ),
          // Glossy shine overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final bool compact;
  const _InfoPanel({required this.compact});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
          compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text('Portfolio',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            )),
        const SizedBox(height: 4),
        Text('Cloud Engineer  |  AI / ML',
            style: tt.bodyMedium?.copyWith(
              color: s.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            )),
        if (!compact) ...[
          const SizedBox(height: 28),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _GlowPill('Cloud Engineer', s),
            _GlowPill('Full-Stack Developer', s),
            _GlowPill('AI / ML', s),
          ]),
        ],
      ],
    );
  }
}

class _GlossyBadge extends StatelessWidget {
  final ColorScheme scheme;
  const _GlossyBadge({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4ADE80).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text('FEATURED PROFILE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4ADE80),
                letterSpacing: 1.2,
              )),
        ),
        const SizedBox(height: 12),
        Text('Oscar Valles',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                )),
        const SizedBox(height: 2),
        Text('Cloud Engineer',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Text(
            'AWS  •  AI  •  PORTFOLIO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String val, label;
  final ColorScheme s;
  const _Stat(this.val, this.label, this.s);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(val,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 18, color: s.primary)),
      const SizedBox(width: 8),
      Text(label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
    ]);
  }
}

class _ScrollHint extends StatefulWidget {
  final Color color;
  const _ScrollHint({required this.color});
  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _c.value * 5),
        child: Icon(Icons.keyboard_arrow_down_rounded,
            size: 20, color: widget.color.withValues(alpha: 0.3)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Section header
// ═══════════════════════════════════════════════════════════════════════════

class _Section extends StatelessWidget {
  final double pad, maxW;
  final String eyebrow, title, sub;
  const _Section({required this.pad, required this.maxW,
      required this.eyebrow, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 900;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: compact ? 34 : 48)),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(sub, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Project strip
// ═══════════════════════════════════════════════════════════════════════════

class _ProjectStrip extends StatelessWidget {
  final double pad, maxW;
  final bool compact, loading;
  final List<Project> projects;
  final Future<void> Function(String) onOpen;

  const _ProjectStrip({required this.pad, required this.maxW,
      required this.compact, required this.loading,
      required this.projects, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: Column(children: [
            Wrap(
              spacing: 18,
              runSpacing: 18,
              children: projects.map((p) => SizedBox(
                width: compact
                    ? double.infinity
                    : (maxW - pad * 2 - 36) / 3,
                child: _ProjCard(project: p, onOpen: onOpen),
              )).toList(),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/projects'),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('View all projects',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded,
                      size: 16, color: Theme.of(context).colorScheme.primary),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ProjCard extends StatefulWidget {
  final Project project;
  final Future<void> Function(String) onOpen;
  const _ProjCard({required this.project, required this.onOpen});
  @override
  State<_ProjCard> createState() => _ProjCardState();
}

class _ProjCardState extends State<_ProjCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final p = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _h ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: s.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _h ? s.primary.withValues(alpha: 0.3) : s.outline.withValues(alpha: 0.08),
          ),
          boxShadow: _h
              ? [BoxShadow(color: s.primary.withValues(alpha: 0.08), blurRadius: 32, offset: const Offset(0, 12))]
              : [BoxShadow(color: s.shadow.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                color: s.surfaceContainerHighest,
                child: (p.imageUrl != null && p.imageUrl!.isNotEmpty)
                    ? Image.network(p.imageUrl!, fit: BoxFit.cover)
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(
                spacing: 6, runSpacing: 6,
                children: p.tags.take(3).map((t) => _Tag(t, s)).toList(),
              ),
              const SizedBox(height: 12),
              Text(p.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(p.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Bento capabilities grid
// ═══════════════════════════════════════════════════════════════════════════

class _BentoGrid extends StatelessWidget {
  final double pad, maxW;
  final bool compact;
  const _BentoGrid({required this.pad, required this.maxW, required this.compact});

  static const _items = [
    (Icons.cloud_outlined, 'Cloud Architecture', 'AWS, Terraform, K8s, CI/CD pipelines, and observability at scale.'),
    (Icons.layers_outlined, 'Product Engineering', 'Full-stack systems that turn complex workflows into usable interfaces.'),
    (Icons.api_outlined, 'Backend & APIs', 'Service design, data modeling, and integrations across modern stacks.'),
    (Icons.shield_outlined, 'Execution Quality', 'Refactoring discipline and code that stays maintainable after launch.'),
  ];

  @override
  Widget build(BuildContext context) {
    final gap = 14.0;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: compact
              ? Column(
                  children: _items.map((i) => Padding(
                    padding: EdgeInsets.only(bottom: gap),
                    child: _BentoCard(icon: i.$1, title: i.$2, desc: i.$3),
                  )).toList(),
                )
              : Column(children: [
                  Row(children: [
                    Expanded(child: _BentoCard(icon: _items[0].$1, title: _items[0].$2, desc: _items[0].$3)),
                    SizedBox(width: gap),
                    Expanded(child: _BentoCard(icon: _items[1].$1, title: _items[1].$2, desc: _items[1].$3)),
                  ]),
                  SizedBox(height: gap),
                  Row(children: [
                    Expanded(child: _BentoCard(icon: _items[2].$1, title: _items[2].$2, desc: _items[2].$3)),
                    SizedBox(width: gap),
                    Expanded(child: _BentoCard(icon: _items[3].$1, title: _items[3].$2, desc: _items[3].$3)),
                  ]),
                ]),
        ),
      ),
    );
  }
}

class _BentoCard extends StatefulWidget {
  final IconData icon;
  final String title, desc;
  const _BentoCard({required this.icon, required this.title, required this.desc});
  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: s.surface.withValues(alpha: _h ? 0.92 : 0.65),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _h ? s.primary.withValues(alpha: 0.2) : s.outline.withValues(alpha: 0.06),
          ),
          boxShadow: _h
              ? [BoxShadow(color: s.primary.withValues(alpha: 0.06), blurRadius: 28, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _h ? s.primary.withValues(alpha: 0.14) : s.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.icon, size: 20, color: s.primary),
          ),
          const SizedBox(height: 18),
          Text(widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(widget.desc, style: Theme.of(context).textTheme.bodyMedium),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CTA
// ═══════════════════════════════════════════════════════════════════════════

class _CtaBlock extends StatelessWidget {
  final double pad, maxW;
  final VoidCallback onContact, onEmail;
  const _CtaBlock({required this.pad, required this.maxW,
      required this.onContact, required this.onEmail});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  s.primary.withValues(alpha: 0.06),
                  s.tertiary.withValues(alpha: 0.04),
                ],
              ),
              border: Border.all(color: s.primary.withValues(alpha: 0.1)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Text('Ready to build something together?',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'I\'m open to full-time roles, contract work, and '
                  'collaborations in cloud engineering.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(spacing: 10, runSpacing: 10, children: [
                _GradientBtn(label: 'Get in Touch', onTap: onContact, scheme: s),
                OutlinedButton(onPressed: onEmail, child: const Text('Email')),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Shared micro-components
// ═══════════════════════════════════════════════════════════════════════════

class _GlowPill extends StatelessWidget {
  final String label;
  final ColorScheme s;
  const _GlowPill(this.label, this.s);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: s.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: s.primary.withValues(alpha: 0.15)),
      ),
      child: Text(label,
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: s.primary, letterSpacing: 0.3,
          )),
    );
  }
}

Widget _Tag(String label, ColorScheme s) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: s.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: s.onSurfaceVariant)),
  );
}

class _GradientBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final ColorScheme scheme;
  const _GradientBtn({required this.label, required this.onTap, required this.scheme});
  @override
  State<_GradientBtn> createState() => _GradientBtnState();
}

class _GradientBtnState extends State<_GradientBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    final s = widget.scheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [s.primary, s.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _h
                ? [BoxShadow(color: s.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 6))]
                : [BoxShadow(color: s.primary.withValues(alpha: 0.15), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Text(widget.label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.2)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Animated gradient mesh background (blue / purple / cyan orbs)
// ═══════════════════════════════════════════════════════════════════════════

class _AnimatedBg extends StatefulWidget {
  const _AnimatedBg();
  @override
  State<_AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<_AnimatedBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => CustomPaint(
        painter: _MeshPainter(p: _c.value, dark: dark),
        size: Size.infinite,
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double p;
  final bool dark;
  _MeshPainter({required this.p, required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _Orb(0.10, 0.16, 0.06, 0.05, 1.0, dark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5), 0.14, 0.40),
      _Orb(0.84, 0.12, 0.05, 0.07, 0.6, dark ? const Color(0xFFA855F7) : const Color(0xFF7C3AED), 0.10, 0.34),
      _Orb(0.45, 0.58, 0.08, 0.04, 1.2, dark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2), 0.08, 0.28),
      _Orb(0.25, 0.86, 0.03, 0.05, 0.7, dark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5), 0.06, 0.22),
    ];
    for (final o in orbs) {
      final a = p * 2 * pi * o.speed;
      final x = (o.bx + sin(a) * o.rx) * size.width;
      final y = (o.by + cos(a * 0.7) * o.ry) * size.height;
      final r = size.width * o.rFrac;
      final c = o.color.withValues(alpha: o.alpha);
      canvas.drawCircle(
        Offset(x, y), r,
        Paint()..shader = RadialGradient(colors: [c, c.withAlpha(0)])
            .createShader(Rect.fromCircle(center: Offset(x, y), radius: r)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter old) => old.p != p;
}

class _Orb {
  final double bx, by, rx, ry, speed;
  final Color color;
  final double alpha, rFrac;
  const _Orb(this.bx, this.by, this.rx, this.ry, this.speed, this.color, this.alpha, this.rFrac);
}
