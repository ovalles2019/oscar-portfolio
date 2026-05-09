import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/projects.dart';
import '../../models/project.dart';
import '../widgets/nav_bar.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with SingleTickerProviderStateMixin {
  List<Project> _all = [];
  bool _loading = true;
  String _filter = 'All';
  late AnimationController _bg;

  List<String> get _cats {
    final c = _all.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...c];
  }

  List<Project> get _filtered =>
      _filter == 'All' ? _all : _all.where((p) => p.category == _filter).toList();

  @override
  void initState() {
    super.initState();
    _bg = AnimationController(vsync: this, duration: const Duration(seconds: 28))..repeat();
    _load();
  }

  Future<void> _load() async {
    try {
      await loadProjects();
      if (!mounted) return;
      setState(() { _all = demoProjects; _loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() { _bg.dispose(); super.dispose(); }

  Future<void> _open(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 900;
    final pad = compact ? 22.0 : 56.0;
    const maxW = 1140.0;
    final s = Theme.of(context).colorScheme;

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
                    Text('PROJECTS', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 16),
                    Text('Work that ships.',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: compact ? 34 : 48)),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Text(
                        'Each project tackles a real problem with thoughtful architecture — from cloud infra to full-stack apps.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!_loading) _Chips(cats: _cats, active: _filter, onTap: (c) => setState(() => _filter = c)),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ),
          ),
          if (_loading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator(color: s.primary, strokeWidth: 2)),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: maxW),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(pad, 0, pad, 80),
                    child: _Grid(projects: _filtered, compact: compact, maxW: maxW - pad * 2, onOpen: _open),
                  ),
                ),
              ),
            ),
        ]),
      ]),
    );
  }
}

class _Chips extends StatelessWidget {
  final List<String> cats;
  final String active;
  final ValueChanged<String> onTap;
  const _Chips({required this.cats, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: cats.map((c) {
        final on = c == active;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onTap(c),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: on
                      ? LinearGradient(colors: [s.primary, s.tertiary])
                      : null,
                  color: on ? null : s.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: on ? Colors.transparent : s.outline.withValues(alpha: 0.08)),
                ),
                child: Text(c,
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: on ? Colors.white : s.onSurfaceVariant,
                    )),
              ),
            ),
          ),
        );
      }).toList()),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<Project> projects;
  final bool compact;
  final double maxW;
  final Future<void> Function(String) onOpen;
  const _Grid({required this.projects, required this.compact, required this.maxW, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final gap = 18.0;
    final w = compact ? double.infinity : (maxW - gap) / 2;
    return Wrap(spacing: gap, runSpacing: gap, children: projects.map((p) =>
        SizedBox(width: w, child: _Card(project: p, onOpen: onOpen))).toList());
  }
}

class _Card extends StatefulWidget {
  final Project project;
  final Future<void> Function(String) onOpen;
  const _Card({required this.project, required this.onOpen});
  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
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
        transform: Matrix4.identity()..translate(0.0, _h ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: s.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _h ? s.primary.withValues(alpha: 0.25) : s.outline.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: _h ? s.primary.withValues(alpha: 0.08) : s.shadow.withValues(alpha: 0.03),
              blurRadius: _h ? 36 : 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: s.surfaceContainerHighest,
                  child: (p.imageUrl != null && p.imageUrl!.isNotEmpty)
                      ? Image.network(p.imageUrl!, fit: BoxFit.cover)
                      : Center(child: Icon(Icons.image_outlined, size: 28, color: s.onSurfaceVariant)),
                ),
              ),
              Positioned(top: 10, left: 10, child: _Badge(p.category, s)),
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: _h ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, s.surface.withValues(alpha: 0.9)],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(12),
                    child: Wrap(spacing: 5, runSpacing: 5,
                        children: p.technologies.take(5).map((t) => _TechPill(t, s)).toList()),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 17),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(p.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 14),
              Row(children: [
                if (p.githubUrl != null && p.githubUrl!.isNotEmpty)
                  _SmBtn(Icons.code_rounded, 'Source', () => widget.onOpen(p.githubUrl!), s),
                const Spacer(),
                AnimatedOpacity(
                  opacity: _h ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(Icons.arrow_outward_rounded, size: 16, color: s.primary),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

Widget _Badge(String label, ColorScheme s) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: s.surface.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: s.outline.withValues(alpha: 0.06)),
    ),
    child: Text(label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: s.primary, letterSpacing: 0.4)),
  );
}

Widget _TechPill(String label, ColorScheme s) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: s.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: s.primary.withValues(alpha: 0.15)),
    ),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: s.primary)),
  );
}

class _SmBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme s;
  const _SmBtn(this.icon, this.label, this.onTap, this.s);
  @override
  State<_SmBtn> createState() => _SmBtnState();
}

class _SmBtnState extends State<_SmBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _h ? widget.s.primary.withValues(alpha: 0.08) : Colors.transparent,
            border: Border.all(
              color: _h ? widget.s.primary.withValues(alpha: 0.15) : widget.s.outline.withValues(alpha: 0.08)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.icon, size: 12, color: _h ? widget.s.primary : widget.s.onSurfaceVariant),
            const SizedBox(width: 5),
            Text(widget.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                color: _h ? widget.s.primary : widget.s.onSurfaceVariant)),
          ]),
        ),
      ),
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
      (0.08, 0.1, 0.7, dark ? const Color(0x106366F1) : const Color(0x084F46E5)),
      (0.88, 0.25, 0.5, dark ? const Color(0x0AA855F7) : const Color(0x067C3AED)),
      (0.4, 0.78, 1.0, dark ? const Color(0x0822D3EE) : const Color(0x040891B2)),
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
