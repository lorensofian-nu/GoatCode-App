import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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
            const SizedBox(height: 28),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Container(
                    width: 3,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, index) {
                final mod = modules[index];
                final completedInMod = mod.lessons
                    .where((l) => user.completedLessons.contains(l.id))
                    .length;
                final isFullyCompleted =
                    mod.lessons.isNotEmpty &&
                    completedInMod == mod.lessons.length;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isFullyCompleted
                                  ? AppColors.successGreen.withValues(
                                      alpha: 0.2,
                                    )
                                  : mod.isUnlocked
                                  ? AppColors.secondaryCyan.withValues(
                                      alpha: 0.2,
                                    )
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
                  ),
                );
              },
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
