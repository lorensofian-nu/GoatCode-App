import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';

/// Comic-style speech bubble for GoatCode mascot tips, encouragement and instructions.
class MascotSpeechBubble extends StatelessWidget {
  final String text;
  final String? title;
  final VoidCallback? onTap;
  final double scale;
  final bool pointsLeft;

  const MascotSpeechBubble({
    super.key,
    required this.text,
    this.title,
    this.onTap,
    this.scale = 1.0,
    this.pointsLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xE61A152E), // 90% opacity deep glass
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(pointsLeft ? 4 : 16),
            bottomRight: Radius.circular(pointsLeft ? 16 : 4),
          ),
          border: Border.all(
            color: AppColors.secondaryCyan.withValues(alpha: 0.6),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryCyan.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 14,
                    color: AppColors.secondaryCyan,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title!,
                    style: TextStyle(
                      color: AppColors.secondaryCyan,
                      fontWeight: FontWeight.w700,
                      fontSize: 12 * scale,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Text(
              text,
              style: AppTypography.body(scale).copyWith(
                color: AppColors.textPrimary,
                fontSize: 13.5 * scale,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    ).animateEntrance(index: 0);
  }
}
