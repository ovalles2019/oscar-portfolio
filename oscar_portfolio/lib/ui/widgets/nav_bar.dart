import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        "Oscar Valles",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: -0.5,
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}
