import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bg;
  @override
  void initState() {
    super.initState();
    _bg = AnimationController(vsync: this, duration: const Duration(seconds: 28))..repeat();
  }

  @override
  void dispose() { _bg.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 900;
    final pad = compact ? 22.0 : 56.0;
    const maxW = 1140.0;

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _bg,
            builder: (_, __) => CustomPaint(
              painter: _Bg(p: _bg.value, dark: Theme.of(context).brightness == Brightness.dark),
              size: Size.infinite,
            ),
          ),
        ),
        CustomScrollView(slivers: [
          const SliverToBoxAdapter(child: NavBar()),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, 48, pad, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('SKILLS & EXPERTISE', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 16),
                    Text('Technologies I use to ship.',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: compact ? 34 : 48)),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Text(
                        'I pick tools based on the problem. Here\'s what I reach for most.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 48),
                  ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, 0, pad, 48),
                  child: _SkillBento(compact: compact, maxW: maxW - pad * 2),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, 0, pad, 80),
                  child: const _BottomBlock(),
                ),
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _SkillBento extends StatelessWidget {
  final bool compact;
  final double maxW;
  const _SkillBento({required this.compact, required this.maxW});

  static const _cats = [
    _C(Icons.cloud_outlined, 'Cloud & DevOps', 'Scalable infrastructure on AWS.',
        ['AWS', 'Docker', 'Kubernetes', 'Terraform', 'CI/CD'], Color(0xFF6366F1)),
    _C(Icons.code_rounded, 'Programming', 'Robust apps across multiple stacks.',
        ['Dart/Flutter', 'Python', 'JavaScript', 'TypeScript', 'Java'], Color(0xFF22D3EE)),
    _C(Icons.storage_rounded, 'Databases', 'Efficient data storage & retrieval.',
        ['DynamoDB', 'PostgreSQL', 'MongoDB', 'Redis', 'Supabase'], Color(0xFFA855F7)),
    _C(Icons.build_circle_outlined, 'Tools & Frameworks', 'Powerful dev workflows.',
        ['Git', 'React', 'Flask', 'Netlify', 'Jenkins'], Color(0xFF34D399)),
  ];

  @override
  Widget build(BuildContext context) {
    final gap = 14.0;
    if (compact) {
      return Column(children: _cats.map((c) => Padding(
        padding: EdgeInsets.only(bottom: gap), child: _SkillCard(cat: c))).toList());
    }
    return Column(children: [
      Row(children: [
        Expanded(child: _SkillCard(cat: _cats[0])),
        SizedBox(width: gap),
        Expanded(child: _SkillCard(cat: _cats[1])),
      ]),
      SizedBox(height: gap),
      Row(children: [
        Expanded(child: _SkillCard(cat: _cats[2])),
        SizedBox(width: gap),
        Expanded(child: _SkillCard(cat: _cats[3])),
      ]),
    ]);
  }
}

class _C {
  final IconData icon;
  final String title, desc;
  final List<String> skills;
  final Color accent;
  const _C(this.icon, this.title, this.desc, this.skills, this.accent);
}

class _SkillCard extends StatefulWidget {
  final _C cat;
  const _SkillCard({required this.cat});
  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final c = widget.cat;

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: s.surface.withValues(alpha: _h ? 0.92 : 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _h ? c.accent.withValues(alpha: 0.25) : s.outline.withValues(alpha: 0.06)),
          boxShadow: _h
              ? [BoxShadow(color: c.accent.withValues(alpha: 0.07), blurRadius: 32, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: _h ? 0.15 : 0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(c.icon, size: 22, color: c.accent),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(c.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18))),
          ]),
          const SizedBox(height: 14),
          Text(c.desc, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          Wrap(spacing: 7, runSpacing: 7, children: c.skills.map((sk) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: c.accent.withValues(alpha: 0.12)),
            ),
            child: Text(sk, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.accent)),
          )).toList()),
        ]),
      ),
    );
  }
}

class _BottomBlock extends StatelessWidget {
  const _BottomBlock();
  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [s.primary.withValues(alpha: 0.05), s.tertiary.withValues(alpha: 0.03)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        border: Border.all(color: s.primary.withValues(alpha: 0.08)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('How I think about tools', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'I expand my toolkit through real projects. Technical depth meets '
          'practical problem-solving — the right tool for the job, not the most popular one.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _Proof(Icons.cloud_done_outlined, 'AWS Solutions Architecture', s),
          _Proof(Icons.school_outlined, 'MS Computer Engineering — UTD', s),
          _Proof(Icons.rocket_launch_outlined, 'Production systems in 5+ stacks', s),
        ]),
      ]),
    );
  }
}

class _Proof extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme s;
  const _Proof(this.icon, this.label, this.s);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: s.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: s.primary.withValues(alpha: 0.1)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: s.primary),
        const SizedBox(width: 7),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: s.primary)),
      ]),
    );
  }
}

class _Bg extends CustomPainter {
  final double p;
  final bool dark;
  _Bg({required this.p, required this.dark});
  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      (0.12, 0.08, 0.6, dark ? const Color(0x0C6366F1) : const Color(0x064F46E5)),
      (0.85, 0.35, 0.4, dark ? const Color(0x08A855F7) : const Color(0x047C3AED)),
      (0.45, 0.82, 0.9, dark ? const Color(0x0622D3EE) : const Color(0x030891B2)),
    ];
    for (final o in orbs) {
      final a = p * 2 * pi * o.$3;
      final x = (o.$1 + sin(a) * 0.04) * size.width;
      final y = (o.$2 + cos(a * 0.7) * 0.03) * size.height;
      final r = size.width * 0.28;
      canvas.drawCircle(Offset(x, y), r,
          Paint()..shader = RadialGradient(colors: [o.$4, o.$4.withAlpha(0)])
              .createShader(Rect.fromCircle(center: Offset(x, y), radius: r)));
    }
  }

  @override
  bool shouldRepaint(covariant _Bg old) => old.p != p;
}
