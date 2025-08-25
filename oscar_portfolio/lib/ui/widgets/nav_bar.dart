import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      title: Text(
        "Oscar Valles",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      actions: [
        _NavButton(
          label: "About",
          onTap: () => _scrollToSection(context, "about"),
        ),
        _NavButton(
          label: "Projects",
          onTap: () => _scrollToSection(context, "projects"),
        ),
        _NavButton(
          label: "Skills",
          onTap: () => _scrollToSection(context, "skills"),
        ),
        _NavButton(
          label: "Contact",
          onTap: () => _scrollToSection(context, "contact"),
        ),
      ],
    );
  }

  void _scrollToSection(BuildContext context, String section) {
    // This will be implemented with scroll controller
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scrolling to $section section...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
