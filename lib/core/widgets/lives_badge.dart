import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_state_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class LivesBadge extends ConsumerStatefulWidget {
  final bool showCountdown;
  final bool compact;

  const LivesBadge({
    super.key,
    this.showCountdown = false,
    this.compact = false,
  });

  @override
  ConsumerState<LivesBadge> createState() => _LivesBadgeState();
}

class _LivesBadgeState extends ConsumerState<LivesBadge> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.showCountdown) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          final user = ref.read(userProfileProvider);
          if (user.lives < user.maxLives) {
            ref.read(userProfileProvider.notifier).refreshLives();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final isLowLives = user.lives <= 1;

    final heartColor = isLowLives
        ? AppColors.warningAmber
        : AppColors.heartYellow;

    return InkWell(
      onTap: () => showLivesDialog(context, ref),
      borderRadius: BorderRadius.circular(20),
      child: Semantics(
        label: 'Vidas disponibles: ${user.lives} de ${user.maxLives}',
        hint: 'Toca para ver el estado de recarga de vidas',
        button: true,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 8 : 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: heartColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: heartColor.withValues(alpha: 0.45)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                user.currentMascotAsset,
                key: ValueKey(user.currentMascotAsset),
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  user.goatMood.showsSadGesture
                      ? Icons.sentiment_dissatisfied
                      : Icons.pets,
                  size: 16,
                  color: heartColor,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                user.lives > 0 ? Icons.favorite : Icons.favorite_border,
                color: heartColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.compact
                    ? '${user.lives}'
                    : '${user.lives}/${user.maxLives}',
                style: TextStyle(
                  color: heartColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13 * scale,
                ),
              ),
              if (widget.showCountdown && user.lives < user.maxLives) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user.formattedTimeUntilNextLife,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11 * scale,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

void showLivesDialog(BuildContext context, WidgetRef ref) {
  showDialog(context: context, builder: (ctx) => const _LivesDialogContent());
}

class _LivesDialogContent extends ConsumerStatefulWidget {
  const _LivesDialogContent();

  @override
  ConsumerState<_LivesDialogContent> createState() =>
      _LivesDialogContentState();
}

class _LivesDialogContentState extends ConsumerState<_LivesDialogContent> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        final user = ref.read(userProfileProvider);
        if (user.lives < user.maxLives) {
          ref.read(userProfileProvider.notifier).refreshLives();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;

    final mascotAsset = user.currentMascotAsset;
    final mood = user.goatMood;

    return Dialog(
      backgroundColor: const Color(0xFF161226),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                mascotAsset,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.favorite,
                  color: AppColors.heartYellow,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Vidas de Aprendizaje',
                style: AppTypography.headingMedium(scale),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Heart icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(user.maxLives, (index) {
                  final isFilled = index < user.lives;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      isFilled ? Icons.favorite : Icons.favorite_border,
                      color: isFilled
                          ? AppColors.heartYellow
                          : AppColors.textMuted.withValues(alpha: 0.4),
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              Text(
                '${user.lives} de ${user.maxLives} vidas disponibles',
                style: AppTypography.headingSmall(scale).copyWith(
                  color: user.lives > 0
                      ? AppColors.heartYellow
                      : AppColors.warningAmber,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: mood.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: mood.color.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mood.icon, size: 15, color: mood.color),
                    const SizedBox(width: 6),
                    Text(
                      'Ánimo: ${mood.displayName}',
                      style: TextStyle(
                        color: mood.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12 * scale,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (user.lives < user.maxLives) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF20172E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.heartYellow.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: AppColors.secondaryCyan,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Próxima vida en:',
                            style: AppTypography.caption(scale),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user.formattedTimeUntilNextLife,
                            style: TextStyle(
                              color: AppColors.secondaryCyan,
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Se recarga 1 vida cada 15 minutos automáticamente.',
                        style: AppTypography.caption(scale).copyWith(
                          fontSize: 11 * scale,
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.successGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.successGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '¡Tus vidas están al máximo!',
                        style: TextStyle(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 13 * scale,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Text(
                'Cada respuesta incorrecta en un reto resta 1 vida. Si tus vidas bajan considerablemente (2 o menos), el gesto de la cabra cambiará a triste para acompañarte.',
                style: AppTypography.caption(scale)
                    .copyWith(color: AppColors.textSecondary, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (user.lives < user.maxLives) ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        ref.read(userProfileProvider.notifier).refillLives();
                      },
                      icon: const Icon(Icons.flash_on, size: 16),
                      label: const Text('Recargar Vidas'),
                    ),
                    const SizedBox(width: 10),
                  ],
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Entendido'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
