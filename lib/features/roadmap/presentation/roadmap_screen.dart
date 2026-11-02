import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/cosmic_card.dart';
import '../../../core/widgets/mascot_speech_bubble.dart';
import '../../lesson/data/sample_lessons.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final modules = SampleLessons.getModules(user.completedLessons);

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.horizontalPadding(context)),
      child: ResponsiveContainer(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ruta de Progreso', style: AppTypography.headingLarge(scale)),
            const SizedBox(height: 6),
            Text(
              'Sigue el camino secuencial para dominar la programación. Puedes volver a cualquier lección anterior para repasar.',
              style: AppTypography.body(scale),
            ),
            const SizedBox(height: 18),
            MascotSpeechBubble(
              title: 'Guía de la Ruta Cósmica',
              text: '¡Cada módulo completado desbloquea el siguiente nivel! Sigue el sendero luminoso para no perderte.',
              scale: scale,
            ),
            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              separatorBuilder: (context, index) {
                final isDone = modules[index].lessons.every(
                  (l) => user.completedLessons.contains(l.id),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Center(
                    child: SizedBox(
                      width: 140,
                      height: 50,
                      child: CustomPaint(
                        painter: _SinuousConnectorPainter(
                          isCompleted: isDone,
                          toRight: index % 2 == 0,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemBuilder: (context, index) {
                final mod = modules[index];
                final completedInMod = mod.lessons
                    .where((l) => user.completedLessons.contains(l.id))
                    .length;
                final isFullyCompleted =
                    mod.lessons.isNotEmpty &&
                    completedInMod == mod.lessons.length;

                return CosmicCard(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isFullyCompleted
                                ? AppColors.successGreen.withValues(alpha: 0.2)
                                : mod.isUnlocked
                                ? AppColors.secondaryCyan.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.05),
                            child: Icon(
                              isFullyCompleted
                                  ? Icons.check_circle_rounded
                                  : mod.isUnlocked
                                  ? Icons.play_circle_outline_rounded
                                  : Icons.lock_outline_rounded,
                              color: isFullyCompleted
                                  ? AppColors.successGreen
                                  : mod.isUnlocked
                                  ? AppColors.secondaryCyan
                                  : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mod.title,
                                  style: AppTypography.headingSmall(scale),
                                ),
                                Text(
                                  mod.description,
                                  style: AppTypography.caption(scale),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isFullyCompleted
                                  ? AppColors.successGreen.withValues(
                                      alpha: 0.15,
                                    )
                                  : AppColors.primaryNeon.withValues(
                                      alpha: 0.15,
                                    ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$completedInMod/${mod.lessons.length}',
                              style: TextStyle(
                                color: isFullyCompleted
                                    ? AppColors.successGreen
                                    : AppColors.secondaryCyan,
                                fontWeight: FontWeight.w700,
                                fontSize: 13 * scale,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.surfaceBorder),
                      const SizedBox(height: 10),

                      ...mod.lessons.map((lesson) {
                        final isCompleted = user.completedLessons.contains(
                          lesson.id,
                        );
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          leading: Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isCompleted
                                ? AppColors.successGreen
                                : AppColors.secondaryCyan,
                            size: 20,
                          ),
                          title: Text(
                            lesson.title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15 * scale,
                            ),
                          ),
                          subtitle: Text(
                            lesson.analogyTitle,
                            style: AppTypography.caption(scale),
                          ),
                          trailing: OutlinedButton(
                            onPressed: mod.isUnlocked
                                ? () => context.go('/lesson/${lesson.id}')
                                : null,
                            child: Text(
                              isCompleted ? 'Repasar' : 'Comenzar',
                              style: TextStyle(fontSize: 13 * scale),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ).animateEntrance(index: index);
              },
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class _SinuousConnectorPainter extends CustomPainter {
  final bool isCompleted;
  final bool toRight;

  _SinuousConnectorPainter({required this.isCompleted, required this.toRight});

  @override
  void paint(Canvas canvas, Size size) {
    final activeColor = isCompleted
        ? AppColors.successGreen
        : AppColors.secondaryCyan;

    final paint = Paint()
      ..color = activeColor.withValues(alpha: 0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = toRight ? size.width * 0.35 : size.width * 0.65;
    final endX = toRight ? size.width * 0.65 : size.width * 0.35;

    path.moveTo(startX, 0);
    path.cubicTo(
      startX,
      size.height * 0.5,
      endX,
      size.height * 0.5,
      endX,
      size.height,
    );

    canvas.drawPath(path, paint);

    // Glowing center waypoint
    final nodePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(center, 9, glowPaint);
    canvas.drawCircle(center, 4.5, nodePaint);
  }

  @override
  bool shouldRepaint(covariant _SinuousConnectorPainter oldDelegate) =>
      oldDelegate.isCompleted != isCompleted || oldDelegate.toRight != toRight;
}
