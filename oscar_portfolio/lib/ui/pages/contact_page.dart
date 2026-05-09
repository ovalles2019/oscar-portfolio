import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../widgets/nav_bar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _msgCtl = TextEditingController();
  final _hp = TextEditingController();
  final _fk = GlobalKey<FormState>();
  bool _sending = false;
  DateTime? _lastSend;
  bool? _supaOk;
  late AnimationController _bg;

  static const _fn = '/.netlify/functions/contact';

  @override
  void initState() {
    super.initState();
    _bg = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
    _checkSupa();
  }

  @override
  void dispose() {
    _bg.dispose();
    _nameCtl.dispose();
    _emailCtl.dispose();
    _msgCtl.dispose();
    _hp.dispose();
    super.dispose();
  }

  Future<void> _checkSupa() async {
    try {
      final r = await http.get(Uri.parse(_fn));
      if (r.statusCode == 200) {
        final d = json.decode(r.body) as Map<String, dynamic>;
        if (mounted) setState(() => _supaOk = d['configured'] == true);
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _supaOk = false);
  }

  Future<void> _submit() async {
    if (!_fk.currentState!.validate()) return;
    if (_supaOk == false) { _toast('Supabase not configured.', err: true); return; }
    if (_hp.text.trim().isNotEmpty) { _toast('Blocked.', err: true); return; }
    if (_lastSend != null && DateTime.now().difference(_lastSend!) < const Duration(seconds: 30)) {
      _toast('Wait before sending again.', err: true); return;
    }
    setState(() => _sending = true);
    try {
      final r = await http.post(Uri.parse(_fn),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _nameCtl.text.trim(),
            'email': _emailCtl.text.trim(),
            'message': _msgCtl.text.trim(),
          }));
      if (r.statusCode == 201 || r.statusCode == 200) {
        _lastSend = DateTime.now();
        _toast('Message sent!');
        _nameCtl.clear(); _emailCtl.clear(); _msgCtl.clear(); _hp.clear();
      } else {
        _toast('Failed (${r.statusCode}).', err: true);
      }
    } catch (_) {
      _toast('Failed. Try again.', err: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _toast(String m, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      backgroundColor: err ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _open(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) await launchUrl(u);
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
                    Text('GET IN TOUCH', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 16),
                    Text('Let\'s build something together.',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: compact ? 34 : 48)),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Text(
                        'Open to roles, contract work, and collaborations. Drop me a line.',
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
                  padding: EdgeInsets.fromLTRB(pad, 0, pad, 80),
                  child: compact
                      ? Column(children: [_form(s), const SizedBox(height: 24), _side(s)])
                      : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(flex: 3, child: _form(s)),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: _side(s)),
                        ]),
                ),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _form(ColorScheme s) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: s.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: s.outline.withValues(alpha: 0.06)),
        boxShadow: [BoxShadow(color: s.shadow.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Form(
        key: _fk,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [s.primary.withValues(alpha: 0.12), s.tertiary.withValues(alpha: 0.08)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.send_rounded, size: 18, color: s.primary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Send a message', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18)),
              const SizedBox(height: 3),
              _SupaChip(ok: _supaOk),
            ])),
          ]),
          const SizedBox(height: 28),
          TextFormField(
            controller: _nameCtl,
            decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline, size: 18)),
            validator: (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailCtl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, size: 18)),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v)) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _msgCtl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message',
              prefixIcon: Padding(padding: EdgeInsets.only(bottom: 56), child: Icon(Icons.message_outlined, size: 18)),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Enter a message' : null,
          ),
          SizedBox(height: 0, width: 0, child: Opacity(opacity: 0,
              child: TextFormField(controller: _hp, decoration: const InputDecoration(labelText: 'Website'), autofillHints: const []))),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _GradBtn(
              label: _sending ? 'Sending...' : 'Send Message',
              icon: _sending ? null : Icons.send_rounded,
              loading: _sending,
              onTap: _sending ? null : _submit,
              scheme: s,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _side(ColorScheme s) {
    return Column(children: [
      _Glass(
        scheme: s,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Quick contact', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18)),
          const SizedBox(height: 18),
          _Link(Icons.email_outlined, 'Email', 'ovalles6845@gmail.com', s.primary, () => _open('mailto:ovalles6845@gmail.com'), s),
          const SizedBox(height: 8),
          _Link(Icons.link_rounded, 'LinkedIn', 'Connect with me', const Color(0xFF0077B5), () => _open('https://www.linkedin.com/in/oscarvalles87/'), s),
          const SizedBox(height: 8),
          _Link(Icons.code_rounded, 'GitHub', 'View my code', s.onSurfaceVariant, () => _open('https://github.com/ovalles2019'), s),
        ]),
      ),
      const SizedBox(height: 14),
      _Glass(
        scheme: s,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: s.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.schedule_rounded, size: 16, color: s.primary),
            ),
            const SizedBox(width: 10),
            Text('Response time', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16)),
          ]),
          const SizedBox(height: 12),
          Text('Typically within 24 hours.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: s.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: s.primary.withValues(alpha: 0.1)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 7, height: 7, decoration: BoxDecoration(
                color: const Color(0xFF4ADE80), shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFF4ADE80).withValues(alpha: 0.5), blurRadius: 5)],
              )),
              const SizedBox(width: 7),
              Text('Available for new projects',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: s.primary)),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

class _SupaChip extends StatelessWidget {
  final bool? ok;
  const _SupaChip({required this.ok});
  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final good = ok ?? false;
    final c = good ? s.primary : s.error;
    final label = ok == null ? 'Checking...' : good ? 'Supabase connected' : 'Not configured';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
    );
  }
}

class _Glass extends StatelessWidget {
  final ColorScheme scheme;
  final Widget child;
  const _Glass({required this.scheme, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.06)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class _Link extends StatefulWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;
  final ColorScheme s;
  const _Link(this.icon, this.label, this.sub, this.color, this.onTap, this.s);
  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _h ? widget.s.primary.withValues(alpha: 0.04) : Colors.transparent,
            border: Border.all(color: _h ? widget.s.outline.withValues(alpha: 0.1) : widget.s.outline.withValues(alpha: 0.04)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Icon(widget.icon, size: 16, color: widget.color),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: widget.s.onSurface)),
              Text(widget.sub, style: TextStyle(fontSize: 11, color: widget.s.onSurfaceVariant)),
            ])),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: widget.s.onSurfaceVariant.withValues(alpha: 0.4)),
          ]),
        ),
      ),
    );
  }
}

class _GradBtn extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onTap;
  final ColorScheme scheme;
  const _GradBtn({required this.label, this.icon, this.loading = false, this.onTap, required this.scheme});
  @override
  State<_GradBtn> createState() => _GradBtnState();
}

class _GradBtnState extends State<_GradBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    final s = widget.scheme;
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [s.primary, s.tertiary]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _h && widget.onTap != null
                ? [BoxShadow(color: s.primary.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 5))]
                : [],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            if (widget.loading)
              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
            else if (widget.icon != null)
              Icon(widget.icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(widget.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
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
      (0.10, 0.12, 0.6, dark ? const Color(0x0A6366F1) : const Color(0x054F46E5)),
      (0.90, 0.30, 0.4, dark ? const Color(0x08A855F7) : const Color(0x047C3AED)),
      (0.42, 0.80, 0.8, dark ? const Color(0x0622D3EE) : const Color(0x030891B2)),
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
