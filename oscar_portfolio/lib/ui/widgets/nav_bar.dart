import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../services/theme_service.dart';
import '../../routes/app_routes.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 800;
    final s = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.65),
            border: Border(
              bottom: BorderSide(color: s.outline.withValues(alpha: 0.08)),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 40),
          child: Row(
            children: [
              _Logo(onTap: () => _go(context, AppRoutes.home), scheme: s),
              const Spacer(),
              if (!compact) ...[
                _NavItem('Home', AppRoutes.home, () => _go(context, AppRoutes.home)),
                _NavItem('Projects', AppRoutes.projects, () => _go(context, AppRoutes.projects)),
                _NavItem('Skills', AppRoutes.skills, () => _go(context, AppRoutes.skills)),
                _NavItem('Contact', AppRoutes.contact, () => _go(context, AppRoutes.contact)),
                const SizedBox(width: 20),
              ],
              const _ThemeBtn(),
              const SizedBox(width: 8),
              _GhBtn(scheme: s),
              if (compact) ...[
                const SizedBox(width: 4),
                _Menu(onNav: (r) => _go(context, r), scheme: s),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext ctx, String route) {
    if (ModalRoute.of(ctx)?.settings.name == route) return;
    Navigator.of(ctx).pushNamedAndRemoveUntil(route, (_) => false);
  }
}

class _Logo extends StatefulWidget {
  final VoidCallback onTap;
  final ColorScheme scheme;
  const _Logo({required this.onTap, required this.scheme});
  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
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
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: _h ? 0.7 : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [s.primary, s.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text('OV',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5)),
              ),
              const SizedBox(width: 10),
              Text('Oscar Valles',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: s.onSurface,
                    letterSpacing: -0.3,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label, route;
  final VoidCallback onTap;
  const _NavItem(this.label, this.route, this.onTap);
  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    final active = current == widget.route;
    final s = Theme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: active
                  ? s.primary.withValues(alpha: 0.12)
                  : _h
                      ? s.onSurface.withValues(alpha: 0.04)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active
                    ? s.primary
                    : _h
                        ? s.onSurface
                        : s.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  final ValueChanged<String> onNav;
  final ColorScheme scheme;
  const _Menu({required this.onNav, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu',
      onSelected: onNav,
      offset: const Offset(0, 48),
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 12,
      shadowColor: scheme.shadow.withValues(alpha: 0.2),
      itemBuilder: (_) => const [
        PopupMenuItem(value: AppRoutes.home, child: Text('Home')),
        PopupMenuItem(value: AppRoutes.projects, child: Text('Projects')),
        PopupMenuItem(value: AppRoutes.skills, child: Text('Skills')),
        PopupMenuItem(value: AppRoutes.contact, child: Text('Contact')),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.08)),
        ),
        child: Icon(Icons.menu_rounded, size: 18, color: scheme.onSurface),
      ),
    );
  }
}

class _GhBtn extends StatefulWidget {
  final ColorScheme scheme;
  const _GhBtn({required this.scheme});
  @override
  State<_GhBtn> createState() => _GhBtnState();
}

class _GhBtnState extends State<_GhBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    final s = widget.scheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: () async {
          final u = Uri.parse('https://github.com/ovalles2019');
          if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [s.primary, s.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _h
                ? [BoxShadow(color: s.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))]
                : [],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.code_rounded, size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text('GitHub',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeBtn extends StatelessWidget {
  const _ThemeBtn();
  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Consumer<ThemeService>(
      builder: (context, ts, _) {
        return GestureDetector(
          onTap: ts.toggleTheme,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: s.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: s.outline.withValues(alpha: 0.08)),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  ts.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(ts.isDarkMode),
                  size: 16,
                  color: s.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
