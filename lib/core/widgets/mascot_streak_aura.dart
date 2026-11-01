import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Levels of streak radiance for the GoatCode mascot.
enum StreakTier {
  cosmic, // 0 - 2 days (Violet Neon)
  fire,   // 3 - 6 days (Amber Fire)
  solar,  // 7+ days (Mythic Solar Gold)
}

extension StreakTierExtension on StreakTier {
  static StreakTier fromStreak(int streak) {
    if (streak >= 7) return StreakTier.solar;
    if (streak >= 3) return StreakTier.fire;
    return StreakTier.cosmic;
  }

  String get label {
    switch (this) {
      case StreakTier.cosmic:
        return 'Aura Cósmica';
      case StreakTier.fire:
        return 'Aura de Fuego';
      case StreakTier.solar:
        return 'Aura Solar';
    }
  }

  Color get primaryColor {
    switch (this) {
      case StreakTier.cosmic:
        return AppColors.primaryNeon;
      case StreakTier.fire:
        return AppColors.streakFire;
      case StreakTier.solar:
        return const Color(0xFFFFD700); // Mythic Radiant Gold
    }
  }

  Color get secondaryColor {
    switch (this) {
      case StreakTier.cosmic:
        return AppColors.secondaryCyan;
      case StreakTier.fire:
        return const Color(0xFFFFB300); // Amber Flare
      case StreakTier.solar:
        return const Color(0xFFFFF275); // Solar Starlight
    }
  }

  IconData get icon {
    switch (this) {
      case StreakTier.cosmic:
        return Icons.auto_awesome;
      case StreakTier.fire:
        return Icons.local_fire_department;
      case StreakTier.solar:
        return Icons.wb_sunny_rounded;
    }
  }
}

/// An adaptive glowing aura around the goat mascot that evolves visually
/// with the user daily streak (Cosmic Violet -> Fire Amber -> Solar Gold).
class MascotStreakAura extends StatelessWidget {
  final Widget child;
  final int streak;
  final double size;
  final bool showBadge;
  final double scale;

  const MascotStreakAura({
    super.key,
    required this.child,
    required this.streak,
    this.size = 140,
    this.showBadge = true,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final tier = StreakTierExtension.fromStreak(streak);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Caustic Radial Glow
            Container(
              width: size * 1.15,
              height: size * 1.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    tier.primaryColor.withValues(alpha: 0.35),
                    tier.secondaryColor.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),

            // Inner Ring Accent
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: tier.primaryColor.withValues(alpha: 0.40),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: tier.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
          ],
        ),

        if (showBadge) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF130E24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: tier.primaryColor.withValues(alpha: 0.45),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: tier.primaryColor.withValues(alpha: 0.20),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tier.icon,
                  size: 13 * scale,
                  color: tier.primaryColor,
                ),
                const SizedBox(width: 5),
                Text(
                  '$streak d • ${tier.label}',
                  style: TextStyle(
                    color: tier.secondaryColor,
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
