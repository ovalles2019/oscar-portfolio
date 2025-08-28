import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/project.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isHovered 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7280).withOpacity(0.08), // Soft gray shadow
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: const Color(0xFF6B7280).withOpacity(0.12), // Slightly stronger on hover
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: widget.project.link != null ? () => _launchUrl(widget.project.link!) : null,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.project.title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _isHovered 
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          if (widget.project.link != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _isHovered 
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.open_in_new,
                                color: _isHovered 
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.project.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _isHovered 
                            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.8)
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: widget.project.tags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _isHovered 
                                      ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _isHovered 
                                        ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                                        : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                      width: _isHovered ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _isHovered 
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      if (widget.project.link != null) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 16,
                              color: _isHovered 
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Click to view project',
                              style: TextStyle(
                                color: _isHovered 
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
