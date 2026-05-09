import 'package:flutter/material.dart';

class ElegantButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final Color? glowColor;

  const ElegantButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isPrimary = true,
    this.padding,
    this.width,
    this.glowColor,
  });

  @override
  State<ElegantButton> createState() => _ElegantButtonState();
}

class _ElegantButtonState extends State<ElegantButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? 
        (widget.isPrimary 
            ? const Color(0xFF00D4FF) 
            : Theme.of(context).colorScheme.primary);
    
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                color: widget.isPrimary 
                    ? const Color(0xFF1A1A1A)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isPrimary 
                      ? const Color(0xFF2A2A2A)
                      : glowColor.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  // Subtle base shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  // Glow effect
                  if (_isHovered)
                    BoxShadow(
                      color: glowColor.withOpacity(0.4 * _glowAnimation.value),
                      blurRadius: 20 * _glowAnimation.value,
                      offset: const Offset(0, 0),
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  // Right-side glow (matching the image)
                  if (_isHovered)
                    BoxShadow(
                      color: glowColor.withOpacity(0.6 * _glowAnimation.value),
                      blurRadius: 15 * _glowAnimation.value,
                      offset: const Offset(8, 0),
                      spreadRadius: 1 * _glowAnimation.value,
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.onPressed,
                  child: Container(
                    padding: widget.padding ?? 
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: 18,
                            color: widget.isPrimary 
                                ? Colors.white
                                : glowColor,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.isPrimary 
                                ? Colors.white
                                : glowColor,
                            letterSpacing: 0.2,
                          ),
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
}

class ElegantIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? glowColor;

  const ElegantIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.glowColor,
  });

  @override
  State<ElegantIconButton> createState() => _ElegantIconButtonState();
}

class _ElegantIconButtonState extends State<ElegantIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? const Color(0xFF00D4FF);
    
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2A2A2A),
                  width: 1,
                ),
                boxShadow: [
                  // Subtle base shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  // Glow effect
                  if (_isHovered)
                    BoxShadow(
                      color: glowColor.withOpacity(0.4 * _glowAnimation.value),
                      blurRadius: 20 * _glowAnimation.value,
                      offset: const Offset(0, 0),
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  // Right-side glow
                  if (_isHovered)
                    BoxShadow(
                      color: glowColor.withOpacity(0.6 * _glowAnimation.value),
                      blurRadius: 15 * _glowAnimation.value,
                      offset: const Offset(8, 0),
                      spreadRadius: 1 * _glowAnimation.value,
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.onPressed,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: Colors.white,
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
}

