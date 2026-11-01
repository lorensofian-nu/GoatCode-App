import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_state_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

/// An interactive card supporting both "Cristal Cósmico" (frosted mirror glassmorphism)
/// and "Obsidiana Mate" (solid, high-contrast, zero-glare matte finish).
class CosmicCard extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? glowColor;
  final double borderRadius;
  final bool enableHoverEffect;
  final bool? enableGlassEffect;

  const CosmicCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.glowColor,
    this.borderRadius = 20.0,
    this.enableHoverEffect = true,
    this.enableGlassEffect,
  });

  @override
  ConsumerState<CosmicCard> createState() => _CosmicCardState();
}

class _CosmicCardState extends ConsumerState<CosmicCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _sheenController;

  bool get _isGlass {
    if (widget.enableGlassEffect != null) return widget.enableGlassEffect!;
    try {
      return ref.watch(accessibilityProvider).glassEffectEnabled;
    } catch (_) {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _sheenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _sheenController.dispose();
    super.dispose();
  }

  void _onEnter(dynamic _) {
    if (widget.enableHoverEffect && mounted) {
      setState(() => _isHovered = true);
      if (_isGlass && !AppMotion.isTestEnvironment) {
        _sheenController.forward(from: 0.0);
      }
    }
  }

  void _onExit(dynamic _) {
    if (widget.enableHoverEffect && mounted) {
      setState(() => _isHovered = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        AppMotion.isTestEnvironment;
    final isHovering = widget.enableHoverEffect && _isHovered && !disableAnimations;
    final activeGlow = widget.glowColor ?? AppColors.primaryNeon;
    final isGlass = _isGlass;

    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: _onEnter,
        onExit: _onExit,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppMotion.durationMicro,
            curve: AppMotion.curveEnter,
            transform: Matrix4.translationValues(0, isHovering ? -4 : 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: !isGlass
                  ? (widget.backgroundColor ?? const Color(0xFF141026))
                  : null,
              border: !isGlass
                  ? Border.all(
                      color: isHovering
                          ? activeGlow.withValues(alpha: 0.70)
                          : AppColors.surfaceBorder,
                      width: isHovering ? 1.5 : 1.2,
                    )
                  : null,
              boxShadow: [
                // 1. Ambient Occlusion Shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: isHovering ? 0.38 : 0.25),
                  blurRadius: isHovering ? 14 : 8,
                  offset: const Offset(0, 4),
                ),
                // 2. Refracted Caustic Glow (only when glass or hovered)
                if (isGlass || isHovering)
                  BoxShadow(
                    color: activeGlow.withValues(
                      alpha: isGlass ? (isHovering ? 0.18 : 0.06) : 0.12,
                    ),
                    blurRadius: isHovering ? 20 : 12,
                    spreadRadius: isHovering ? 1.0 : 0,
                    offset: Offset(0, isHovering ? 6 : 3),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: !isGlass
                  ? Padding(
                      padding: widget.padding,
                      child: widget.child,
                    )
                  : BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: CustomPaint(
                        foregroundPainter: _SpecularBorderPainter(
                          borderRadius: widget.borderRadius,
                          borderWidth: isHovering ? 1.3 : 1.0,
                          glowColor: activeGlow,
                          isHovering: isHovering,
                        ),
                        child: AnimatedBuilder(
                          animation: _sheenController,
                          builder: (context, child) {
                            return CustomPaint(
                              foregroundPainter: _LightSheenPainter(
                                progress: _sheenController.value,
                                borderRadius: widget.borderRadius,
                                active: isHovering,
                              ),
                              child: child,
                            );
                          },
                          child: Container(
                            padding: widget.padding,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isHovering
                                    ? [
                                        const Color(0x14FFFFFF),
                                        (widget.backgroundColor ??
                                                const Color(0xFF16122A))
                                            .withValues(alpha: 0.96),
                                        const Color(0xFC0F0B1E),
                                      ]
                                    : [
                                        const Color(0x0AFFFFFF),
                                        (widget.backgroundColor ??
                                                const Color(0xFF141026))
                                            .withValues(alpha: 0.93),
                                        const Color(0xF70C091A),
                                      ],
                                stops: const [0.0, 0.12, 1.0],
                              ),
                            ),
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws a beveled specular border reflecting light from top-left to shadow bottom-right.
class _SpecularBorderPainter extends CustomPainter {
  final double borderRadius;
  final double borderWidth;
  final Color glowColor;
  final bool isHovering;

  _SpecularBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.glowColor,
    required this.isHovering,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(borderWidth / 2),
      Radius.circular(borderRadius),
    );

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isHovering
          ? [
              Colors.white.withValues(alpha: 0.45), // Soft mirror edge reflection
              glowColor.withValues(alpha: 0.40),    // Gentle neon refraction
              glowColor.withValues(alpha: 0.15),
              Colors.white.withValues(alpha: 0.06),
            ]
          : [
              Colors.white.withValues(alpha: 0.22), // Soft specular highlight
              glowColor.withValues(alpha: 0.15),
              AppColors.surfaceBorder.withValues(alpha: 0.15),
              Colors.white.withValues(alpha: 0.02), // Gentle shadow fade
            ],
      stops: const [0.0, 0.25, 0.70, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _SpecularBorderPainter oldDelegate) =>
      oldDelegate.isHovering != isHovering ||
      oldDelegate.glowColor != glowColor ||
      oldDelegate.borderWidth != borderWidth;
}

/// Paints a diagonal light sheen sweep across the glass surface on hover.
class _LightSheenPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final bool active;

  _LightSheenPainter({
    required this.progress,
    required this.borderRadius,
    required this.active,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!active || progress <= 0.0 || progress >= 1.0) return;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.clipRRect(rrect);

    final totalWidth = size.width + size.height + 250;
    final currentX = -120 + (progress * totalWidth);

    final sheenPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.02),
          Colors.white.withValues(alpha: 0.07), // Soft sheen: text remains crisp & clear
          Colors.white.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(currentX - 100, 0, 200, size.height));

    canvas.drawRect(
      Rect.fromLTWH(currentX - 100, 0, 200, size.height),
      sheenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LightSheenPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.active != active;
}
