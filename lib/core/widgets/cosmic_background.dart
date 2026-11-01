import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Provides a cosmic background with ambient radial light orbs (violet & cyan)
/// that give depth to glassmorphic cards and floating UI components.
class CosmicBackground extends StatelessWidget {
  final Widget child;

  const CosmicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark background
        Positioned.fill(
          child: Container(
            color: AppColors.backgroundDark,
          ),
        ),

        // Top-left Violet Nebula Orb
        Positioned(
          top: -120,
          left: -100,
          child: IgnorePointer(
            child: Container(
              width: 500,
              height: 500,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x188A4FFF), // Soft ambient violet neon (~9%)
                    Color(0x088A4FFF),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Bottom-right Cyan Astral Orb
        Positioned(
          bottom: -150,
          right: -120,
          child: IgnorePointer(
            child: Container(
              width: 550,
              height: 550,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x1200E5FF), // Soft ambient cyan neon (~7%)
                    Color(0x0500E5FF),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Foreground content
        Positioned.fill(child: child),
      ],
    );
  }
}
