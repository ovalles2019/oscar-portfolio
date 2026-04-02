import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/project.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _liftAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    _liftAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool hovered) {
    setState(() => _isHovered = hovered);
    if (hovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _liftAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _liftAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: _isHovered
                      ? theme.colorScheme.primary.withOpacity(0.35)
                      : theme.colorScheme.outline.withOpacity(0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      theme.brightness == Brightness.dark ? 0.24 : 0.08,
                    ),
                    blurRadius: _isHovered ? 30 : 18,
                    offset: Offset(0, _isHovered ? 18 : 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: widget.onTap ?? () => _showProjectDetails(context),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProjectMedia(project: project),
                        const SizedBox(height: 18),
                        Text(
                          project.category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(project.title, style: theme.textTheme.headlineMedium),
                        const SizedBox(height: 10),
                        Text(
                          project.description,
                          style: theme.textTheme.bodyLarge,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: project.tags
                              .take(4)
                              .map((tag) => Chip(label: Text(tag)))
                              .toList(),
                        ),
                        if (project.features.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          ...project.features.take(2).map(
                                (feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Icon(
                                          Icons.circle,
                                          size: 7,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showProjectDetails(context),
                                icon: const Icon(Icons.visibility_outlined, size: 18),
                                label: const Text('Details'),
                              ),
                            ),
                            if (project.primaryLink != null) ...[
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () => _launchUrl(project.primaryLink!),
                                icon: const Icon(Icons.open_in_new_rounded),
                                tooltip: 'Open project',
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  foregroundColor: theme.colorScheme.onSurface,
                                  padding: const EdgeInsets.all(14),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProjectDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => ProjectDetailsModal(project: widget.project),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ProjectMedia extends StatelessWidget {
  final Project project;

  const _ProjectMedia({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: project.imageUrl != null && project.imageUrl!.isNotEmpty
            ? Image.network(
                project.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _FallbackMedia(
                  icon: Icons.image_outlined,
                  label: project.category,
                ),
              )
            : _FallbackMedia(
                icon: project.videoUrl != null && project.videoUrl!.isNotEmpty
                    ? Icons.play_circle_outline_rounded
                    : Icons.dashboard_customize_outlined,
                label: project.category,
              ),
      ),
    );
  }
}

class _FallbackMedia extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FallbackMedia({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.18),
            theme.colorScheme.secondary.withOpacity(0.14),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: theme.colorScheme.primary),
            const SizedBox(height: 10),
            Text(label, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsModal extends StatelessWidget {
  final Project project;

  const ProjectDetailsModal({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.category.toUpperCase(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(project.title, style: theme.textTheme.displayMedium),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProjectMedia(project: project),
                    const SizedBox(height: 24),
                    Text(project.detailedDescription, style: theme.textTheme.bodyLarge),
                    if (project.features.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      Text('Highlights', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      ...project.features.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  size: 18,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (project.technologies.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      Text('Technology stack', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: project.technologies
                            .map((tech) => Chip(label: Text(tech)))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (project.liveUrl != null && project.liveUrl!.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(project.liveUrl!),
                            icon: const Icon(Icons.public_rounded),
                            label: const Text('Live demo'),
                          ),
                        if (project.demoUrl != null && project.demoUrl!.isNotEmpty)
                          FilledButton.tonalIcon(
                            onPressed: () => _launchUrl(project.demoUrl!),
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            label: const Text('Demo'),
                          ),
                        if (project.githubUrl != null && project.githubUrl!.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => _launchUrl(project.githubUrl!),
                            icon: const Icon(Icons.code_rounded),
                            label: const Text('GitHub'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
