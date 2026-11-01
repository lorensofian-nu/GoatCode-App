import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';

/// A fixed horizontal reading progress bar with cosmic neon glow.
/// Indicates real-time scrolling progress through the lesson theory.
class ReadingProgressBar extends StatelessWidget implements PreferredSizeWidget {
  final double progress;
  final double height;
  final Color? glowColor;

  const ReadingProgressBar({
    super.key,
    required this.progress,
    this.height = 3.5,
    this.glowColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final activeGlow = glowColor ?? AppColors.secondaryCyan;

    return Semantics(
      label: 'Progreso de lectura de la lección: ${(clampedProgress * 100).toInt()}%',
      value: '${(clampedProgress * 100).toInt()}%',
      child: Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFF140F26),
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final activeWidth = constraints.maxWidth * clampedProgress;
            return AnimatedContainer(
              duration: AppMotion.durationMicro,
              curve: AppMotion.curveEnter,
              width: activeWidth,
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryNeon,
                    AppColors.secondaryCyan,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: activeGlow.withValues(alpha: 0.6),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
