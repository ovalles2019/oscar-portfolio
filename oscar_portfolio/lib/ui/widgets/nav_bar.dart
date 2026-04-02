import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/theme_service.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentSection;
  final ValueChanged<String> onSectionSelected;

  const NavBar({
    super.key,
    required this.currentSection,
    required this.onSectionSelected,
  });

  static const _sections = <String>['about', 'projects', 'skills', 'contact'];

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.of(context).size.width < 900;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: preferredSize.height - 16,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.72),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.35),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Oscar Valles',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Cloud engineer • Full-stack developer',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (!isCompact) ...[
                    ..._sections.map(
                      (section) => _NavButton(
                        label: _labelFor(section),
                        isActive: currentSection == section,
                        onTap: () => onSectionSelected(section),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const _ThemeToggleButton(),
                  const SizedBox(width: 10),
                  if (isCompact)
                    PopupMenuButton<String>(
                      tooltip: 'Navigate sections',
                      onSelected: onSectionSelected,
                      itemBuilder: (context) => _sections
                          .map(
                            (section) => PopupMenuItem<String>(
                              value: section,
                              child: Text(_labelFor(section)),
                            ),
                          )
                          .toList(),
                      child: _ActionShell(
                        child: Icon(
                          Icons.menu_rounded,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    )
                  else
                    const _GitHubButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _labelFor(String section) {
    switch (section) {
      case 'about':
        return 'About';
      case 'projects':
        return 'Projects';
      case 'skills':
        return 'Skills';
      case 'contact':
        return 'Contact';
      default:
        return section;
    }
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.72),
          backgroundColor: isActive
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _GitHubButton extends StatelessWidget {
  const _GitHubButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: _launchGitHub,
      icon: const Icon(Icons.code_rounded, size: 18),
      label: const Text('GitHub'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _launchGitHub() async {
    const url = 'https://github.com/ovalles2019';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return IconButton(
          onPressed: themeService.toggleTheme,
          tooltip: themeService.isDarkMode
              ? 'Switch to light mode'
              : 'Switch to dark mode',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Icon(
              themeService.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              key: ValueKey(themeService.isDarkMode),
            ),
          ),
          style: IconButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            padding: const EdgeInsets.all(14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

class _ActionShell extends StatelessWidget {
  final Widget child;

  const _ActionShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
